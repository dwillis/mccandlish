module Mccandlish

  class Article
    
    attr_reader :id, :web_url, :snippet, :lead_paragraph, :abstract, :print_page, :blog, :source, :headline_seo, :headline,
    :headline_print, :keywords, :date, :document_type, :news_desk, :byline, :type_of_material, :id, :word_count, :results, 
    :byline, :section_name, :subsection_name, :kicker
    
    def initialize(params={})
      params.each_pair do |k,v|
       instance_variable_set("@#{k}", v)
      end
    end
    
    def self.create_from_results(results)
      results.map{|result| Article.create(result)}
    end
    
    def self.create(result)
      self.new(:id => result['_id'],
      :web_url => result['web_url'],
      :snippet => result['snippet'],
      :lead_paragraph => result['lead_paragraph'],
      :abstract => result['abstract'],
      :print_page => result['print_page'],
      :blog => result['blog'],
      :source => result['source'],
      :headline_seo => result['headline']['seo'],
      :headline => result['headline']['main'],
      :kicker => result['headline']['kicker'],
      :headline_print => result['headline']['print'],
      :keywords => result['keywords'],
      :date => Date.parse(result['pub_date']),
      :document_type => result['document_type'],
      :news_desk => result['news_desk'],
      :section_name => result['section_name'],
      :subsection_name => result['subsection_name'],
      :byline => result['byline'],
      :type_of_material => result['type_of_material'],
      :word_count => result['word_count']
      )
    end
    
    
    
    
    
  end
end