module Mccandlish

  class Result
    
    attr_reader :hits, :offset, :copyright, :status, :articles
    
    def initialize(params={})
      params.each_pair do |k,v|
       instance_variable_set("@#{k}", v)
      end
    end
    
    def self.create_from_parsed_response(results)
      self.new(:hits => results['response']['meta']['hits'],
        :offset => results['response']['meta']['offset'],
        :copyright => results['copyright'],
        :status => results['status'],
        :articles => Article.create_from_results(results['response']['docs'])
      )
    end
    
    
  end
end