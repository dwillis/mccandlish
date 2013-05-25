require 'httparty'
require 'oj'
require 'cgi'
require 'net/http'

module Mccandlish

  class Client
    
    include HTTParty
    
    attr_reader :web_url, :snippet, :lead_paragraph, :abstract, :print_page, :blog, :source, :multimedia, :headline,
    :keywords, :pub_date, :document_type, :news_desk, :byline, :type_of_material, :id, :word_count, :query_filters, 
    :date_filers, :sort, :page, :facet_field_filters, :facet_filter, :search, :api_key, :params
    
    def initialize(query, api_key=nil)
      @api_key = api_key
      @params = {'q' => query}
      @query_filters = {}
      @date_filters = {}
      @sort = {}
      @page = {}
      @facet_field_filters = {}
      @facet_filter = {}
    end

    ##
		# Builds a request URI to call the API server
		def build_request_url(params)
		  "http://api.nytimes.com/svc/search/v2/articlesearch.json?"+params
		end

		def prepare_params(params, api_key)
		  params.map {|k,v| "#{CGI.escape(k)}=#{CGI.escape(v.to_s)}"}.join('&')+"&api-key=#{api_key}"
		end

    def invoke(params={})
			raise "You must initialize the API key before you run any API queries" if self.api_key.nil?
			full_params = prepare_params(params, api_key=self.api_key)
			uri = build_request_url(full_params)
			response = HTTParty.get(uri)
			check_response(response)
    end

    def check_response(response)
      raise "Authentication Error" if response.code == 403
      raise "Bad Request" if response.code == 400
      raise "Server Error" if response.code == 500
      if response.code == 200
        Oj.load(response.body)
      else
        return nil
      end
    end
    
    def search(params)
      invoke(params)
    end
    
    def dates(begin_date, end_date)
      date_filters['begin_date'] = begin_date if begin_date
      date_filters['end_date'] = end_date if end_date
      params.merge!(date_filters)
      self.search(self.params)
    end
    
    def word_count(start, finish)
      
      
    end
      
  end
  
end