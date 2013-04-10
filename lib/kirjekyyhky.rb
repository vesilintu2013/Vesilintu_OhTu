require 'rack'
require 'net/http'
require 'net/https'
module Kirjekyyhky 
  class Interface
    BOUNDARY = "AaB03x"
    def self.send_form_structure 
      credentials = YAML.load(File.open(Rails.root.join("config/kirjekyyhky.yml")))

      uri = URI("#{credentials["url"]}/post/structure/")
      p "uri: #{credentials["url"]}/post/structure"
      p "username: #{credentials["username"]}"
      p "password: #{credentials["password"]}"

      file = "lib/vesilintu-testi.xml"

      post_body = []
      post_body << "--#{BOUNDARY}\r\n"
      post_body << "Content-Disposition: form-data; name=\"xml\"; filename=\"#{File.basename(file)}\"\r\n"
      post_body << "Content-Type: application/xml\r\n"
      post_body << "\r\n"
      post_body << File.read(file)
      post_body << "\r\n--#{BOUNDARY}--\r\n"

      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      req = Net::HTTP::Post.new uri.request_uri
      req.basic_auth credentials["username"], credentials["password"]
      req.body = post_body.join
      req["Content-Type"] = "multipart/form-data, boundary=#{BOUNDARY}"

      res = http.request(req)

#      req.add_field "Content-Type", "application/xml; charset=\"UTF-8\""
#      xml = IO.read(Rails.root.join("lib/vesilintu-testi.xml"))
#      req.body = xml

#      res = http.start do |http|
#        http.request(req)
#      end
      if res.code == "200"
        return res.body
      else
        throw "Response failed, code: #{res.code}, body: #{res.body}"
      end
    end

  end
end
