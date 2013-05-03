require 'tipuapi'
module MuseumData

  # The MuseumData::Parser class specified below provides functionality for parsing the provided
  # old-format data into a ruby hash, which can then be further converted into Rails model objects if
  # so desired. 
  #
  # Parser class uses MuseumData::DATA_FIELDS constant, which contains the name, width and type of the
  # datafields in the old format text data. There is no data validation done, all is to be handled within
  # the actual Rails model. This parsing information is derived from the documentation delivered by Heikki
  # Lokki.
  #
  # Some details of the parsing process:
  # - Empty fields are marked as nil in the hash
  # - Float values in the format "99,9" are converted first to "99.9" and then to float 99.9
  # - Boolean values are either 1 for true and 0 for false, other values result to nil
  # - EEE-coordinate is a special case. The coordinate system uses three numbers for the North
  #   East coordinates, but only two numbers are present in the old data for EEE-coordinate, since
  #   all of them start with the number 3 when pointing at Finland. To clear things up, integer
  #   300 is added to all EEE-coordinates, so that they are consistent with the NNN-coordinates
  class Parser

    def initialize
      init_errors
    end

    def errors
      @errors
    end

    def print_errors
      print_errors_for :routes
      print_errors_for :places
      print_errors_for :observations
    end

    def parse filename
      init_errors
      data = parse_data filename
      ActiveRecord::Base.transaction do
        data.each do |data_hash|

          observation, place, route = generate_models data_hash

          if !route.new_record? || route.valid?
            route.save! if route.new_record?
            place.route_id = route.id
            observation.route_id = route.id
          else
            add_to_errors :routes, data_hash[:original_data], route
            next
          end

          if place.valid?
            place.save!
            observation.place_id = place.id
          else
            add_to_errors :places, data_hash[:original_data], place
            next
          end

          if observation.valid?
            observation.save!
            generate_counts data_hash[:counts_data], observation.id
          else
            add_to_errors :observations, data_hash[:original_data], observation
            next
          end

        end
      end
    end

    private

    def init_errors
      @errors = {:places => [], :observations => [], :routes => []}
    end

    def generate_log_filename type
      File.join(Rails.root, "/log/museum_#{type}_error_log_#{Time.now.to_formatted_s(:number)}")
    end

    def print_errors_for type
      File.open(generate_log_filename(type.to_s), "w" ) do |f|
        @errors[type].each do |error|
          f.puts "Model"
          f.puts error[:model].inspect
          f.puts "Validation errors"
          f.puts error[:errors].inspect
          f.puts "Original data"
          f.puts error[:data]
          f.puts "---------------------------------------"
        end
      end
    end

    def add_to_errors type, original_data, model
      @errors[type] << {:errors => model.errors, :model => model, :data => original_data}
    end

    def generate_counts counts_data, id
      counts_data.keys.each do |key|
        values = "(#{id},'#{key}',#{counts_data[key].nil? ? "NULL" : counts_data[key]})"
        sql = "INSERT INTO counts ('observation_id','abbr','count') values #{values}"
        ActiveRecord::Base.connection.execute(sql)
      end
    end

    def generate_models data_hash
      observation_hash, place_hash, route_hash = generate_model_hashes(data_hash)

      route = Route.where(:route_number => route_hash[:route_number], :year => route_hash[:year]).first
      if route.nil?
        route = Route.new(route_hash)
      end
      place = Place.new(place_hash)
      place.source = "museum"
      observation = Observation.new(observation_hash)

      [observation, place, route]

    end

    def parse_data filename
      output = []
      abbreviations = TipuApi::Interface.species["species"].map{|s| s["id"].downcase.to_sym}
      File.open(filename).each_line do |line|
        observation = parse_observation(line.strip!, abbreviations)
        output << observation unless observation.nil?
      end
      output
    end


    def generate_model_hashes data_hash
      observation_hash = {}
      route_hash = {}
      place_hash = {}

      data_hash.keys.each do |key|
        observation_hash[key] = data_hash[key] if OBSERVATIONS_FIELDS.include? key
        route_hash[key] = data_hash[key] if ROUTES_FIELDS.include? key
        place_hash[key] = data_hash[key] if PLACES_FIELDS.include? key
      end

      observation_hash[:first_observation_date] = generate_date data_hash, "first"
      observation_hash[:second_observation_date] = generate_date data_hash, "second"


      beginning_place, end_place = calculate_covering_area data_hash[:places_which_cover_whole_water_system]

      place_hash[:covering_area_beginning] = beginning_place
      place_hash[:covering_area_end] = end_place

      observation_hash[:source] = "museum"

      [observation_hash, place_hash, route_hash] 

    end

    def calculate_covering_area places_string

      unless places_string == nil
        if places_string =~ /-/
          places_string = places_string.split("-")
        else
          places_string = places_string.split(" ")
        end
      end

      if places_string != nil && places_string.count == 2
        [places_string.first.to_i, places_string.last.to_i]
      else
        [nil, nil]
      end
    end

    def generate_date hash, prefix
      date = nil
      month = "#{prefix}_observation_date_month".to_sym
      day = "#{prefix}_observation_date_day".to_sym

      begin
        date = Date.new(hash[:year],hash[month],hash[day])
      rescue
        puts "PROBLEM, first date wrong: #{hash[:year]},#{hash[month]},#{hash[day]}"
        puts "Original: #{hash[:original_data]}"
      end

      return date
    end

    def parse_observation line, abbreviations
      return if line.nil?
      observation = {}
      offset = 0

      # The functionality is quite simple. Value is read from the line using offset and width,
      # and afterwards the offset is incremented by the width. Value is stripped of whitespace
      # and converted to either integer, string or float.
      DATA_FIELDS.each do |field|
        value = line[offset , field[:width]]
        offset += field[:width]
        value = convert_value field[:type], value

        # Special case, see in the comment block above class definition
        if field[:name] == :eee_coordinate
          value += 300
        end

        observation[field[:name]] = value
      end

      # After the specified fields, there is the possibility of having additional observations.
      # These observations follow a specified format of XXXXXXYYY, where X:s are the abbreviation
      # of the species and YYY is the count. These additional observations may either be unlisted
      # species, or additional counts of listed species that did not fit within the 3-character
      # field reserved for counts.
      other_species, additional_counts = parse_other_species line[offset, line.length - offset]

      observation[:other_species] = other_species
      additional_counts.keys.each do |key|
        observation[key] += additional_counts[key]
      end

      observation[:original_data] = line
      observation[:counts_data] = {}

      abbreviations.each do |abbr_key|
        observation[:counts_data][abbr_key] = observation.delete(abbr_key) unless observation[abbr_key].nil?
      end

      observation
    end

    def parse_other_species extra_data
      offset = 0
      other_species = {}
      additional_counts = {}

      while extra_data != nil && offset < extra_data.length
        extra_obs = extra_data[offset, 9]
        offset += 9

        name = extra_obs[0,6].downcase.to_sym
        count = convert_value :integer, extra_obs[6,3]

        if DATA_FIELDS.map{|field| field[:name]}.include? name && !count.nil?
          additional_counts[name] = count
        else
          other_species[name] = count
        end
      end

      return [other_species , additional_counts]
    end

    def convert_value type, value
      return nil if value.nil?
      value.strip!
      return nil if value.empty?

      if type == :integer

        return value.to_i

      elsif type == :float

        return value.gsub(",",".").to_f

      elsif type == :boolean

        return true if value == "1"
        return false if value == "0"

      end

      return value
    end
  end
  SKIP_FIELDS = [:first_observation_date_day,
    :first_observation_date_month,
    :second_observation_date_day,
    :second_observation_date_month,
    :places_which_cover_whole_water_system,
    :other_species,
    :original_data,
    :counts_data,
    :roaming_counting]
  OBSERVATIONS_FIELDS = [
    :year,
    :observer_id,
    :first_observation_hour,
    :first_observation_duration,
    :second_observation_hour,
    :second_observation_duration,
    :spot_counting,
    :binoculars,
    :boat,
    :gullbirds,
    :waders_eurasian_bittern,
    :passerine
  ]

  PLACES_FIELDS = [
    :observation_place_number,
    :nnn_coordinate,
    :eee_coordinate,
    :biotope_class,
    :observation_place_name,
    :place_area,
    :area_covers_fully
  ]
  ROUTES_FIELDS = [
    :year,
    :route_number,
    :municipal_code,
    :route_representative_class,
    :spot_observation_place_count,
    :roaming_observation_place_count,
    :water_system_area
  ]
  DATA_FIELDS = [
    {
    :name => :route_number,
    :width => 4,
    :type => :integer
    },
    {
    :name => :year,
    :width => 4,
    :type => :integer
    },
    {
    :name => :observation_place_number,
    :width => 2,
    :type => :integer
    },
    {
    :name => :observer_id,
    :width => 4,
    :type => :integer
    },
    {
    :name => :municipal_code,
    :width => 6,
    :type => :string
    },
    {
    :name => :nnn_coordinate,
    :width => 3,
    :type => :integer
    },
    {
    :name => :eee_coordinate,
    :width => 2,
    :type => :integer
    },
    {
    :name => :biotope_class,
    :width => 1,
    :type => :integer
    },
    {
    :name => :route_representative_class,
    :width => 1,
    :type => :integer
    },
    {
    :name => :spot_observation_place_count,
    :width => 2,
    :type => :integer
    },
    {
    :name => :roaming_observation_place_count,
    :width => 2,
    :type => :integer
    },
    {
    :name => :observation_place_name,
    :width => 17,
    :type => :string
    },
    {
    :name => :first_observation_date_day,
    :width => 2,
    :type => :integer
    },
    {
    :name => :first_observation_date_month,
    :width => 1,
    :type => :integer
    },
    {
    :name => :first_observation_hour,
    :width => 2,
    :type => :integer
    },
    {
    :name => :first_observation_duration,
    :width => 3,
    :type => :integer
    },
    {
    :name => :second_observation_date_day,
    :width => 2,
    :type => :integer
    },
    {
    :name => :second_observation_date_month,
    :width => 1,
    :type => :integer
    },
    {
    :name => :second_observation_hour,
    :width => 2,
    :type => :integer
    },
    {
    :name => :second_observation_duration,
    :width => 3,
    :type => :integer
    },
    {
    :name => :water_system_area,
    :width => 6,
    :type => :float
    },
    {
    :name => :place_area,
    :width => 6,
    :type => :float
    },
    {
    :name => :area_covers_fully,
    :width => 1,
    :type => :integer
    },
    {
    :name => :places_which_cover_whole_water_system,
    :width => 7,
    :type => :string
    },
    {
    :name => :spot_counting,
    :width => 1,
    :type => :boolean
    },
    {
    :name => :roaming_counting,
    :width => 1,
    :type => :boolean
    },
    {
    :name => :binoculars,
    :width => 1,
    :type => :boolean
    },
    {
    :name => :boat,
    :width => 1,
    :type => :boolean
    },

    {
    :name => :anapla,
    :width => 3,
    :type => :integer
    },
    {
    :name => :anacre,
    :width => 3,
    :type => :integer
    },
    {
    :name => :anaacu,
    :width => 3,
    :type => :integer
    },
    {
    :name => :anacly,
    :width => 3,
    :type => :integer
    },
    {
    :name => :aytfer,
    :width => 3,
    :type => :integer
    },
    {
    :name => :buccla,
    :width => 3,
    :type => :integer
    },
    {
    :name => :mermer,
    :width => 3,
    :type => :integer
    },
    {
    :name => :fulatr,
    :width => 3,
    :type => :integer
    },
    {
    :name => :gavarc,
    :width => 3,
    :type => :integer
    },
    {
    :name => :podcri,
    :width => 3,
    :type => :integer
    },
    {
    :name => :podgri,
    :width => 3,
    :type => :integer
    },
    {
    :name => :podaur,
    :width => 3,
    :type => :integer
    },
    {
    :name => :cygcyg,
    :width => 3,
    :type => :integer
    },
    {
    :name => :ansfab,
    :width => 3,
    :type => :integer
    },
    {
    :name => :bracan,
    :width => 3,
    :type => :integer
    },
    {
    :name => :anapen,
    :width => 3,
    :type => :integer
    },
    {
    :name => :anaque,
    :width => 3,
    :type => :integer
    },
    {
    :name => :aytful,
    :width => 3,
    :type => :integer
    },
    {
    :name => :melfus,
    :width => 3,
    :type => :integer
    },
    {
    :name => :merser,
    :width => 3,
    :type => :integer
    },
    {
    :name => :meralb,
    :width => 3,
    :type => :integer
    },
    {
    :name => :gullbirds,
    :width => 1,
    :type => :boolean
    },
    {
    :name => :larmin,
    :width => 3,
    :type => :integer
    },
    {
    :name => :larrid,
    :width => 3,
    :type => :integer
    },
    {
    :name => :larcan,
    :width => 3,
    :type => :integer
    },
    {
    :name => :stehir,
    :width => 3,
    :type => :integer
    },
    {
    :name => :waders_eurasian_bittern,
    :width => 1,
    :type => :boolean
    },
    {
    :name => :galgal,
    :width => 3,
    :type => :integer
    },
    {
    :name => :trigla,
    :width => 3,
    :type => :integer
    },
    {
    :name => :trineb,
    :width => 3,
    :type => :integer
    },
    {
    :name => :trioch,
    :width => 3,
    :type => :integer
    },
    {
    :name => :acthyp,
    :width => 3,
    :type => :integer
    },
    {
    :name => :numarq,
    :width => 3,
    :type => :integer
    },
    {
    :name => :vanvan,
    :width => 3,
    :type => :integer
    },
    {
    :name => :botste,
    :width => 3,
    :type => :integer
    },
    {
    :name => :passerine,
    :width => 1,
    :type => :boolean
    },
    {
    :name => :embsch,
    :width => 3,
    :type => :integer
    },
    {
    :name => :acrsch,
    :width => 3,
    :type => :integer
    }
  ]

end
