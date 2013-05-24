require 'httparty'
require 'oj'
require 'cgi'
require 'net/http'

module Mccandlish
  
  class Base

    @@api_key = nil
    
    # Set the API key used for operations. This needs to be called before any requests against the API. To obtain an API key, go to http://developer.nytimes.com/
		def self.api_key=(key)
			@@api_key = key
		end
    
    def self.api_key
			@@api_key
		end
		
    ##
		# Builds a request URI to call the API server
		def self.build_request_url(params)
		  "http://api.nytimes.com/svc/search/v2/articlesearch.json?"+params
		end
		
		def self.prepare_params(params, api_key)
		  params.map {|k,v| "#{CGI.escape(k)}=#{CGI.escape(v.to_s)}"}.join('&')+"&api-key=#{api_key}"
		end
    
    def self.invoke(params={})
			raise "You must initialize the API key before you run any API queries" if @@api_key.nil?
			full_params = prepare_params(params, api_key=self.api_key)
			uri = build_request_url(full_params)
			response = HTTParty.get(uri)
			check_response(response)
    end
    
    def self.check_response(response)
      raise "Authentication Error" if response.code == 403
      raise "Bad Request" if response.code == 400
      raise "Server Error" if response.code == 500
      if response.code == 200
        Oj.load(response.body)
      else
        return nil
      end
    end
    
  end
  
  
end