require 'httparty'
require 'oj'
require 'cgi'
require 'net/http'

module Mccandlish

  class Article
    
    attr_reader :web_url, :snippet, :lead_paragraph, :abstract, :print_page, :blog, :source, :multimedia, :headline,
    :keywords, :pub_date, :document_type, :news_desk, :byline, :type_of_material, :id, :word_count
    
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
    
    def initialize
      @api_path = ''
      @query_filters = {}
      @date_filters = {}
      @sort = {}
      @page = {}
      @facet_field_filters = {}
      @facet_filter = {}
    end
    
    def self.build_and_invoke(params)
      
      
    end
    
    
    def self.search(query)
      params = {'q' => query}
      self
    end
    
    def self.date_range(opts)
      
      self
    end
      
  end
  
end