# encoding: utf-8
module RktlData
  class Parser

    def initialize
      init_errors
    end


    def test_everything
      parse "pair_test", "places_test", "counts_2011_test", "counts_2012_test"
    end

    def parse pair_data_filename, places_data_filename, counts_upto_2011_filename, counts_2012_filename
      init_errors
      data = parse_files pair_data_filename, places_data_filename, counts_upto_2011_filename, counts_2012_filename

      ActiveRecord::Base.transaction do
        create_places data[:places_data]
        combined_counts_data = combine_counts_data data[:counts_upto_2011_data], data[:counts_2012_data]
        create_observations data[:pairs_data], combined_counts_data
      end
      nil
    end

    def print_errors
      print_errors_for :places
      print_errors_for :observations
      print_errors_for :counts
    end

    def errors
      @errors
    end


    private

    def print_errors_for type
      File.open(generate_log_filename(type.to_s), "w" ) do |f|
        @errors[type].each do |error|
          f.puts "Model Hash"
          if type == :counts
            f.puts error.inspect
          else
            f.puts error[:hash].inspect
            f.puts "Validation errors"
            f.puts error[:errors].inspect
            f.puts "Original data"
            f.puts error[:data].inspect
          end
          f.puts "--------------------------------"
        end
      end
    end

    def generate_log_filename type
      File.join(Rails.root, "/log/#{type}_error_log_#{Time.now.to_formatted_s(:number)}")
    end

    def init_errors
      @errors = {:places => [], :observations => [], :counts => []}
    end

    def create_places places_data
      places_data.each do |data|
        place_hash = generate_place_hash data
        place = Place.new(place_hash)

        if place.valid?
          place.save
        else
          @errors[:places] << {:errors => place.errors, :data => data, :hash => place_hash}
          next
        end
      end
    end

    def generate_place_hash data
      hash = {}
      hash[:observation_place_number] = data[:pnro]
      hash[:nnn_coordinate] = data[:y] #TODO convert format!
      hash[:eee_coordinate] = data[:x] #TODO convert format!
      hash[:biotope_class] = data[:type]
      hash[:place_area] = data[:sekala]
      hash[:rktl_munincipal_code] = data[:kunta]
      hash[:rktl_pog_society_id] = data[:rhynro]
      hash[:rktl_town] = data[:kyla]
      hash[:rktl_zip] = data[:po]
      hash[:rktl_it] = data[:it]
      hash[:rktl_map_number] = data[:karnro]
      hash[:rktl_map_name] = data[:karnim]
      hash[:rktl_shore_length] = data[:sek_ranta]
      hash[:rktl_pog_zone_id] = data[:projekti]
      hash[:rktl_project] = data[:projekti]
      hash[:rktl_place_not_counted] = data[:pistetta_ei_lasketa] #Boolean
      hash[:rktl_other] = data[:huom]
      hash[:source] = "rktl"
      hash
    end

    def parse_files pair_data_filename, places_data_filename, counts_upto_2011_filename, counts_2012_filename
      data = {}
      data[:pairs_data] = parse_file " ", pair_data_filename
      data[:places_data] = parse_file ";", places_data_filename
      data[:counts_upto_2011_data] = parse_file ";", counts_upto_2011_filename
      data[:counts_2012_data] = parse_file ";", counts_2012_filename

      data
    end

    def parse_file separator, filename
      output = []
      lines = File.readlines(filename).map{|s| s.gsub("\n","").split(separator)}
      keys = lines.delete_at(0).map{|s| s.gsub("\"","").gsub("ä","a").downcase.to_sym}
      lines.each do |line|
        data = {}
        line = convert_space_separated line if separator == " "
        line.map{|s| s.gsub("\"","")}.each_with_index do |value, i|
          value = value.to_i if value =~ /\A\d*\z/
          value = value.to_f if value =~ /\A\d*,\d*\z/
          data[keys[i]] = value
        end
        output << data
      end
      output
    end

    def convert_space_separated array
      output = []
      index = 0
      while(index < array.length)
        if(array[index] =~ /\A"\w*\z/)
          value = array[index]
          index += 1
          while(array[index] !~ /\A\w*"\z/)
            value = "#{value} #{array[index]}"
            index += 1
          end
          value = "#{value} #{array[index]}"
          value.gsub!("\"","")
          output << value
        else
          output << array[index]
        end
        index += 1
      end

      output
    end

    def combine_counts_data upto_2011_data, year_2012_data
      combined = []
      upto_2011_data.each do |count|
        binoculars = (count[:lasit] == 1 ? 1 : 0)
        telescope = (count[:lasit] == 2 ? 1 : 0)
        combined << {:pnro => count[:pnro], 
          :census => 1, 
          :pvm => (count[:pvm1].nil? ? nil : count[:pvm1].split(" ").first), 
          :hour => count[:hh1], 
          :duration => count[:kesto1],
          :binoculars => binoculars,
          :rktl_telescope => telescope}

        combined << {:pnro => count[:pnro], 
          :census => 2, 
          :pvm => (count[:pvm2].nil? ? nil : count[:pvm2].split(" ").first), 
          :hour => count[:hh2], 
          :duration => count[:kesto2],
          :binoculars => binoculars,
          :rktl_telescope => telescope}

      end

      year_2012_data.each do |count|
        combined << {:pnro => count[:laskentapiste], 
          :census => (count[:laskenta2] + 1),
          :pvm => count[:pvm_klo].split(" ").first,
          :hour => count[:pvm_klo].split(" ").last.split(":").first,
          :duration => count[:kesto],
          :binoculars => count[:kiikari],
          :rktl_telescope => count[:kaukoputki]}
      end

      combined
    end

    def create_observations pairs_data, combined_counts
      grouped_observations = group_observations pairs_data, combined_counts
      grouped_observations.each do |obs|

        observation_hash = generate_observation_and_counts_hashes obs
        observation = Observation.new(observation_hash)

        if observation.valid?

          observation.save!
          obs[:results].each do |count_hash|
            values = "(#{observation.id},'#{count_hash[:abbr]}','#{count_hash[:hav].nil? ? "NULL" : count_hash[:hav]}')"
            sql = "INSERT INTO counts ('observation_id','abbr','pre_result') values #{values}"
            ActiveRecord::Base.connection.execute(sql)
          end

        else
          @errors[:observations] << {:errors => observation.errors, :data => obs, :hash => observation_hash}
          next
        end
      end
    end

    def generate_observation_and_counts_hashes obs
      observation_hash = {}
      observation_hash[:place_id] = Place.where(:observation_place_number => obs[:pnro], :source => "rktl").first.id
      observation_hash[:year] = obs[:vuosi]
      if obs[:pvm] =~ /-/
        date_array = obs[:pvm].split("-")
        begin
          observation_hash[:first_observation_date] = Date.new(date_array[0].to_i,date_array[1].to_i,date_array[2].to_i)
        rescue
          raise date_array.inspect
        end
      else
        date_array = obs[:pvm].split(".")
        begin
          observation_hash[:first_observation_date] = Date.new(date_array[2].to_i,date_array[1].to_i,date_array[0].to_i)
        rescue
          raise date_array.inspect
        end
      end
      observation_hash[:first_observation_hour] = obs[:hour]
      observation_hash[:first_observation_duration] = obs[:duration]
      observation_hash[:binoculars] = (obs[:binoculars] == 1)
      observation_hash[:source] = "rktl"

      observation_hash
    end

    def group_observations pairs_data, combined_counts
      bucket = {}
      pairs_data.each do |pair|
        pair_sym = "pair_#{pair[:pnro]}_#{pair[:vuosi]}_#{pair[:census]}".to_sym
        bucket[pair_sym] = [] if bucket[pair_sym].nil?
        bucket[pair_sym] << pair
      end
      bucket.keys.each do |key|
        bucket[key] = flatten_group(bucket[key])
      end
      combined_counts.each do |count|
        if count[:pvm].nil?
          @errors[:counts] << count
          next
        else
          pair_sym = "pair_#{count[:pnro]}_#{count[:pvm].split(".").last}_#{count[:census]}".to_sym
          unless bucket[pair_sym].nil?
            bucket[pair_sym][:hour] = count[:hour] if bucket[pair_sym][:hour].nil?
            bucket[pair_sym][:duration] = count[:duration] if bucket[pair_sym][:duration].nil?
          end
        end
      end
      bucket.values
    end

    def flatten_group group
      birds = []
      group.each do |obs|
        birds << {:abbr => BIRD_IDS[obs[:laji].to_i], :hav => obs[:hav]}
      end
      flattened_group = {}
      group.first.keys.each do |key|
        flattened_group[key] = group.first[key] unless [:laji, :result].include? key
      end
      flattened_group[:results] = birds
      flattened_group

    end

    def bird_id_to_abbr id
      BIRD_IDS[id.to_i]
    end
    BIRD_IDS = {11 => "anapla",
      12 => "anacre",
      13 => "anapen",
      14 => "anaacu",
      15 => "anacly",
      16 => "anaque",
      17 => "anastr",
      18 => "tadtad",
      21 => "aytful",
      22 => "aytmar",
      23 => "aytfer",
      31 => "buccla",
      32 => "clahye",
      41 => "melfus",
      42 => "melnig",
      43 => "sommol",
      51 => "mermer",
      52 => "merser",
      53 => "meralb",
      61 => "ansans",
      62 => "ansfab",
      63 => "ansery",
      64 => "bracan",
      65 => "braleu",
      71 => "cygolo",
      72 => "cygcyg",
      81 => "gavarc",
      82 => "gavste",
      83 => "podcri",
      84 => "podgri",
      85 => "podaur",
      86 => "tacruf",
      91 => "fulatr",
      98 => "others"}
  end
end
