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

    def self.generate_models filename
      #TODO Rails model creation from the data below.
      #return nil
      data = parse_data filename
      data.each do |observation|
        model = Observation.new(generate_model_hash(observation))
        if !model.valid?
          # Do something smart here! Create good error messages!
          puts "Error creating model, original data:"
          puts observation[:original_data]
        else
          model.save!
	  observation[:counts_data].keys.each do |key|
            Count.create(:observation_id => model.id, :bird_id => Bird.find_by_abbr(key.to_s).id, :count => observation[:counts_data][key])
	  end
        end
      end
    end

    def self.parse_data filename
      output = []
      File.open(filename).each_line do |line|
        observation = parse_observation(line.strip!)
        output << observation unless observation.nil?
      end
      output
    end

    private

    def self.generate_model_hash observation
      hash = {}
      observation.keys.each do |key|
        next if SKIP_FIELDS.include? key #Certain fields are not used directly.
        hash[key] = observation[key]
      end

      begin
        hash[:first_observation_date] = Date.new(hash[:year],observation[:first_observation_date_month],observation[:first_observation_date_day])
      rescue
        puts "PROBLEM, first date wrong: #{hash[:year]},#{observation[:first_observation_date_month]},#{observation[:first_observation_date_day]}"
        puts "Original: #{observation[:original_data]}"
      end

      begin
        hash[:second_observation_date] = Date.new(hash[:year],observation[:second_observation_date_month],observation[:second_observation_date_day])
      rescue
        puts "PROBLEM, second date wrong: #{hash[:year]},#{observation[:second_observation_date_month]},#{observation[:second_observation_date_day]}"
        puts "Original: #{observation[:original_data]}"
      end

      covering_area = observation[:places_which_cover_whole_water_system]
      unless covering_area == nil
        if covering_area =~ /-/
          covering_area = covering_area.split("-")
        else
          covering_area = covering_area.split(" ")
        end
      end

      if covering_area != nil && covering_area.count == 2
        hash[:covering_area_beginning] = covering_area.first.to_i
        hash[:covering_area_end] = covering_area.last.to_i
      else
        hash[:covering_area_beginning] = nil
        hash[:covering_area_end] = nil
      end
      hash[:source] = "museum"
      hash

    end

    def self.parse_observation line
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
      Bird.all.map{|b| b.abbr.to_sym}.each do |abbr_key|
        observation[:counts_data][abbr_key] = observation.delete(abbr_key) 
      end

      observation
    end

    def self.parse_other_species extra_data
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

    def self.convert_value type, value
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
