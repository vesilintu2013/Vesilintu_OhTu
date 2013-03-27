require 'net/http'
require 'net/https'
module TipuApi
  class Interface
    def self.ringers filter = ""
      make_request("ringers", filter)["ringers"]
    end

    def self.species filter = ""
      make_request("species", filter)["species"]
    end

    def self.make_request endpoint, filter = ""
      credentials = YAML.load(File.open(Rails.root.join("config/tipu.yml")))

      if endpoint.class == Array
        endpoint = endpoint.join("/")
      end

      uri = URI("#{credentials["url"]}#{endpoint}/?format=json#{filter.empty? ? "" : "&filter=#{filter}"}")

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

  end
end
