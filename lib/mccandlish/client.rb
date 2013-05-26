require 'httparty'
require 'oj'
require 'cgi'

module Mccandlish

  class Client
    
    include HTTParty
    
    attr_reader :web_url, :snippet, :lead_paragraph, :abstract, :print_page, :blog, :source, :multimedia, :headline_seo,
    :keywords, :pub_date, :document_type, :news_desk, :byline, :type_of_material, :id, :word_count, :sort, :page, 
    :facet_field_filters, :facet_filter, :query, :api_key, :params, :results, :byline, :section_name, :subsection_name,
    :headline_main, :headline_print, :query_filters, :result, :uri
    
    def initialize(api_key=nil)
      @api_key = api_key
      @params = {}
      @query_filters = []
      @uri
    end
    
    # clears out params, query_filters 
    def reset
      @params = {}
      @query_filters = []
      self
    end

    # Builds a request URI to call the API server
    def build_request_url(params)
      "http://api.nytimes.com/svc/search/v2/articlesearch.json?"+params
    end

    def prepare_params(params, api_key)
      params.map {|k,v| k+':'+v.to_s}.join('&')+"&api-key=#{api_key}"
    end

    def invoke(params={})
      raise "You must initialize the API key before you run any API queries" if self.api_key.nil?
      full_params = prepare_params(params, api_key=self.api_key)
      @uri = build_request_url(full_params)
      response = HTTParty.get(@uri)
      check_response(response)
    end

    def check_response(response)
      raise "Authentication Error" if response.code == 403
      raise "Bad Request" if response.code == 400
      raise "Server Error" if response.code == 500
      raise "Timeout" if response.code == 504
      if response.code == 200
        Oj.load(response.body)
      else
        return nil
      end
    end
    
    def result
      invoke(params)
    end
    
    def query(query)
      params['q'] = CGI.escape(query)
      params.merge!({'fq' => query_filters.uniq.join("+AND+")})
      self
    end
    
    # newest or oldest
    def sort(sort)
      params['sort'] = sort
      self
    end
    
    # response has maximum of 10 items, page is for pagination of results
    def page(page)
      params['page'] = page
    end
    
    def dates(begin_date, end_date)
      params['begin_date'] = begin_date if begin_date
      params['end_date'] = end_date if end_date
      self
    end
    
    # Full day name: Monday, Tuesday, Wednesday, etc.
    def day_of_week(day)
      query_filters << "day_of_week:'#{day}'"
      self
    end
    
    # YYYY-MM-DD format
    def date(date)
      query_filters << "pub_date:#{date}"
      self
    end
    
    def year(year)
      query_filters << "pub_year:#{year}"
      self
    end
    
    def location(location)
      loc = CGI.escape(location)
      query_filters << "glocations:'#{loc}'"
      self
    end
      
  end
  
end