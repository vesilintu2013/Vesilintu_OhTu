require 'rack'
require 'net/http'
require 'net/https'
module Kirjekyyhky 
  class Interface
    BOUNDARY = "AaB03x"

    # Update Kirjekyyhky form structure. 
    def self.send_form_structure file 
      credentials = YAML.load(File.open(Rails.root.join("config/kirjekyyhky.yml")))

      uri = URI("#{credentials["url"]}/post/structure/")

      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      req = Net::HTTP::Post.new uri.request_uri
      req.basic_auth credentials["username"], credentials["password"]
      post_body = create_form_structure_post_body(file)
      req.body = post_body.join
      req["Content-Type"] = "multipart/form-data, boundary=#{BOUNDARY}"

      res = http.request(req)

      if res.code == "200"
        return res.body
      else
        throw "Response failed, code: #{res.code}, body: #{res.body}"
      end
    end

    def self.validate_form form_data
      observation_hash, route_hash, place_hash = generate_model_hashes form_data
            
      year = parse_year_from_dates form_data["first_observation_date"], form_data["second_observation_date"]
      route_hash[:year] = year
      # This validation service validates form submissions for both existing and new routes. New routes
      # are assigned a route_number through some additional logic when actually creating the Route record. 
      # route_number cannot be empty in an actual Route record, therefore it needs to be assigned
      # a dummy value for validation purposes. 
      route_hash[:route_number] = 9001
      observation = Observation.new(observation_hash)
      route = Route.new(route_hash)
      place = Place.new(place_hash)

      errors = generate_common_error_hash observation, route, place
    end
    
    private
      def self.create_form_structure_post_body file
        post_body = []
        post_body << "--#{BOUNDARY}\r\n"
        post_body << "Content-Disposition: form-data; name=\"xml\"; filename=\"#{File.basename(file)}\"\r\n"
        post_body << "Content-Type: application/xml\r\n"
        post_body << "\r\n"
        post_body << File.read(file)
        post_body << "\r\n--#{BOUNDARY}--\r\n"
      end

      def self.parse_year_from_dates first_observation_date, second_observation_date
        unless first_observation_date.nil?
          date = first_observation_date
        else
          date = second_observation_date
        end
        
        year = date.split('.')[2] 
      end
      
      def self.generate_model_hashes form_data
        observation_hash = {}
        route_hash = {}
        place_hash = {}

        form_data.keys.each do |key|
          key = key.to_sym
          observation_hash[key] = form_data[key.to_s] if OBSERVATIONS_FIELDS.include? key
          route_hash[key] = form_data[key.to_s] if ROUTES_FIELDS.include? key
          place_hash[key] = form_data[key.to_s] if PLACES_FIELDS.include? key
        end
      
        [observation_hash, route_hash, place_hash]
      end

      def self.generate_common_error_hash observation, route, place
        errors = {}

        unless observation.valid?
          observation.errors.keys.each do |key|
            errors[key] = observation.errors[key]
          end
        end
      
        unless route.valid?
          route.errors.keys.each do |key|
            errors[key] = route.errors[key]
          end
        end
      
        unless place.valid?
          place.errors.each do |key|
            errors[key] = place.errors[key]
          end
        end
        
        errors
      end
  end
  
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
end
