require 'net/http'
require 'net/https'
module TipuApi
  class Interface
    def self.ringers filter = ""
      make_request("ringers", filter)["ringers"]
    end

    def self.observer_synonyms filter = ""
      make_request("observer-synonyms", filter)["observer-synonyms"]
    end

    def self.species filter = ""
      make_request("species", filter)["species"]
    end

    def self.municipalities filter = ""
      make_request("municipalities", filter)["municipalities"]
    end

    def self.validate_coordinates municipality = "", lat = "", lon = ""
      coordinate_validation_request municipality, lat, lon, type = "UNIFORM", format = "JSON"
    end

    def self.make_request endpoint, filter = ""
      credentials = YAML.load(File.open(Rails.root.join("config/tipu.yml")))

      if endpoint.class == Array
        endpoint = endpoint.join("/")
      end

      uri = URI.parse(URI.encode("#{credentials["url"]}#{endpoint}/?format=json#{filter.empty? ? "" : "&filter=#{filter}"}"))

      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true

      req = Net::HTTP::Get.new(uri.request_uri)
      req.basic_auth credentials["username"], credentials["password"]

      res = http.start do |http|
        http.request(req)
      end
      if res.code == "200"
        return ActiveSupport::JSON.decode(res.body)
      else
        throw "Response failed, code: #{res.code}"
      end
    end

    def self.coordinate_validation_request municipality, lat, lon, type, format
      credentials = YAML.load(File.open(Rails.root.join("config/tipu.yml")))

      uri = URI.parse("#{credentials["url"]}coordinate-validation-service")

      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true

      req = Net::HTTP::Post.new(uri.request_uri)
      req.basic_auth credentials["username"], credentials["password"]

      req.set_form_data({ "municipality" => municipality,
                          "lat" => lat,
                          "lon" => lon,
                          "type" => type,
                          "format" => format })

      res = http.start do |http|
        http.request(req)
      end
      if res.code == "200"
        return ActiveSupport::JSON.decode(res.body)
      else
        throw "Response failed, code: #{res.code}"
      end
    end
  end
end
