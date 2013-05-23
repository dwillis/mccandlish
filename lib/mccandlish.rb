%w(article.rb base.rb version.rb).each do |f|
  require File.join(File.dirname(__FILE__), 'mccandlish/', f)
end

module Mccandlish
  # Your code goes here...
end
