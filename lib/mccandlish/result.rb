module Mccandlish

  class Result
    
    attr_reader :hits, :offset, :copyright, :status
    
    def self.create_from_parsed_results(parsed_results)
      self.new(:hits => parsed_results['response']['meta']['hits'],
        :offset => parsed_results['response']['meta']['offset'],
        :copyright => parsed_results['copyright'],
        :status => parsed_results['status'],
        :articles => Article.create_from_results(parsed_results['response']['docs'])
      )
      results
    end
    
    
  end
end