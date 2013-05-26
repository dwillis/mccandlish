require 'httparty'
require 'oj'
require 'cgi'

module Mccandlish

  class Client
    
    include HTTParty
    
    attr_reader :sort, :page, :query_filters, :result, :uri, :query, :api_key, :params
    
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
      params.map {|k,v| k+'='+v.to_s}.join('&')+"&api-key=#{api_key}"
    end

    def invoke(params={})
      raise "You must initialize the API key before you run any API queries" if self.api_key.nil?
      full_params = prepare_params(params, api_key=self.api_key)
      @uri = build_request_url(full_params)
      response = HTTParty.get(@uri)
      parsed_response = check_response(response)
      Result.create_from_parsed_response(parsed_response)
    end

    def check_response(response)
      # replace with actual error handling
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
      query_filters << "day_of_week:#{day}"
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
      query_filters << "glocations:#{loc}"
      self
    end
    
    # article, blogpost
    def doc_type(doc_type)
      query_filters << "document_type:#{doc_type}"
      self
    end
    
    # Foreign, Sports, Culture, etc.
    def desk(desk)
      # validate desk
      query_filters << "news_desk:#{desk}"
      self
    end
  end
  
end