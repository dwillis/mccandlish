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
      @uri = ''
    end
    
    def to_s
      "<McCandlish>"
    end
    
    # clears out params, query_filters 
    def reset
      @params = {}
      @query_filters = []
      @uri = ''
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
    
    # optionally surround multi-word queries with quotes to search for exact matches of phrases
    def query(query, phrase=false)
      if phrase
        q = %q[]
        params['q'] = query.gsub(" ","+").gsub('"',"'")
      else
        params['q'] = CGI.escape(query)
      end
      params.merge!({'fq' => query_filters.uniq.join("+AND+")}) unless query_filters.empty?
      self
    end
    
    # newest or oldest
    def sort(sort)
      params['sort'] = sort if sort == 'newest' or sort == 'oldest'
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
    
    # Foreign, Sports, Culture, etc. - some AP pieces have 'None' as desk
    def desk(desk)
      # validate desk
      query_filters << "news_desk:#{desk}"
      self
    end
    
    # similar to desk, but seems to be always populated
    def section(section)
      query_filters << "section_name:#{section}"
      self
    end
        
    # NYT Index terms
    def organization(organization)
      org = CGI.escape(organization)
      query_filters << "organizations:#{org}"
      self
    end
    
    # NYT Index terms
    def person(person)
      per = CGI.escape(person)
      query_filters << "persons:#{per}"
      self
    end
    
    # NYT Index terms
    def subject(subject)
      subj = CGI.escape(subject)
      query_filters << "subject:#{subj}"
      self
    end
    
    # AP, Reuters, IHT, The New York Times
    def source(source)
      sou = CGI.escape(source)
      query_filters << "source:#{sou}"
      self
    end
    
    # source, section_name, document_type, type_of_material and day_of_week
    def facet(facet_field)
      params['facet_field'] = facet_field
      params['facet_filter'] = true
      self
    end
    
  end
  
end