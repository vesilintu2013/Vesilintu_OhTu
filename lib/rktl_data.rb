# encoding: utf-8
module RktlData
  class Parser


    def self.test_everything
      parse "pair_test", "places_test", "counts_2011_test", "counts_2012_test"
    end

    def self.parse pair_data_filename, places_data_filename, counts_upto_2011_filename, counts_2012_filename
      data = parse_files pair_data_filename, places_data_filename, counts_upto_2011_filename, counts_2012_filename

      ActiveRecord::Base.transaction do
        create_places data[:places_data]
        combined_counts_data = combine_counts_data data[:counts_upto_2011_data], data[:counts_2012_data]
        create_observations data[:pairs_data], combined_counts_data
      end
    end

    private

    def self.create_places places_data
      places_data.each do |data|
        place_hash = generate_place_hash data
        place = Place.new(place_hash)

        if place.valid?
          place.save
        else
          #TODO Generate errorz
          next
        end
      end
    end

    def self.generate_place_hash data
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

    def self.parse_files pair_data_filename, places_data_filename, counts_upto_2011_filename, counts_2012_filename
      data = {}
      data[:pairs_data] = parse_file " ", pair_data_filename
      data[:places_data] = parse_file ";", places_data_filename
      data[:counts_upto_2011_data] = parse_file ";", counts_upto_2011_filename
      data[:counts_2012_data] = parse_file ";", counts_2012_filename

      data
    end

    def self.parse_file separator, filename
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

    def self.convert_space_separated array
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

    def self.combine_counts_data upto_2011_data, year_2012_data
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

    def self.create_observations pairs_data, combined_counts
      grouped_observations = group_observations pairs_data.clone, combined_counts
      grouped_observations.each do |obs|

        observation_hash, count_hashes = generate_observation_and_counts_hashes obs
        observation = Observation.new(observation_hash)

        if observation.valid?

          observation.save!
          counts = count_hashes.map do |count_hash|
            "(#{observation.id},'#{count_hash[:abbr]}','#{count_hash[:hav].nil? ? "NULL" : count_hash[:hav]}')"

          end
          sql = "INSERT INTO counts ('observation_id','abbr','pre_result') values #{counts.join(",")}"
          ActiveRecord::Base.connection.execute(sql)
        else
          #ERRORZ
          next
        end
      end
    end

    def self.generate_observation_and_counts_hashes obs
      observation_hash = {}
      observation_hash[:place_id] = Place.where(:observation_place_number => obs[:pnro], :source => "rktl").first.id
      observation_hash[:year] = obs[:vuosi]
      if obs[:census] == 1
        date_array = obs[:pvm].split("-")
        begin
          observation_hash[:first_observation_date] = Date.new(date_array[0].to_i,date_array[1].to_i,date_array[1].to_i)
        rescue
          raise date_array.inspect
        end
        observation_hash[:first_observation_hour] = obs[:hour]
        observation_hash[:first_observation_duration] = obs[:duration]
      else
        date_array = obs[:pvm].split(".")
        observation_hash[:first_observation_date] = Date.new(date_array[2].to_i,date_array[1].to_i,date_array[0].to_i)
        observation_hash[:first_observation_hour] = obs[:hour]
        observation_hash[:first_observation_duration] = obs[:duration]
      end
      observation_hash[:binoculars] = (obs[:binoculars] == 1)
      observation_hash[:source] = "rktl"

      [observation_hash, obs[:results]]
    end

    def self.group_observations pairs_data, combined_counts

      observations = []
      while(!pairs_data.empty?)
        first = pairs_data.first

        group = pairs_data.select do |obs|
          (obs[:pnro] == first[:pnro]) && (obs[:vuosi] == first[:vuosi]) && (obs[:census] == first[:census])
        end

        pairs_data.delete_if do |obs|
          (obs[:pnro] == first[:pnro]) && (obs[:vuosi] == first[:vuosi]) && (obs[:census] == first[:census])
        end
        
        next if group.empty?

        flattened_group = flatten_group group

        extra_data = combined_counts.select do |s|
          (s[:pvm].nil? ? nil : s[:pvm].split(".").last) == flattened_group[:vuosi] && s[:pnro] == flattened_group[:pnro] && s[:census] == flattened_group[:census]
        end

        flattened_group[:hour] = extra_data.first[:hour] unless extra_data.empty?
        flattened_group[:duration] = extra_data.first[:duration] unless extra_data.empty?


        observations << flattened_group
      end
      observations
    end

    def self.flatten_group group
      birds = []
      group.each do |obs|
        birds << {:abbr => obs[:laji], :hav => obs[:hav]}
      end
      flattened_group = {}
      group.first.keys.each do |key|
        flattened_group[key] = group.first[key] unless [:laji, :result].include? key
      end
      flattened_group[:results] = birds
      flattened_group

    end




  end
end
