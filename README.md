# McCandlish

A thin Ruby wrapper for NYT Article Search API Version 2. The name comes from McCandlish Phillips, ["a tenacious reporter and a lyrical stylist"](http://www.nytimes.com/2013/04/10/business/media/mccandlish-phillips-times-reporter-dies-at-85.html?pagewanted=all) for The New York Times from 1952 to 1973.

## Installation

Add this line to your application's Gemfile:

    gem 'mccandlish'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install mccandlish

## Usage

You'll need an API key from [The New York Times](http://developer.nytimes.com/). Reading the [Article Search V2 API docs](http://developer.nytimes.com/docs/read/article_search_api_v2) wouldn't hurt, either. But once you have a key, you can get started like so:

```ruby
require 'mccandlish'

c = Mccandlish::Client.new('YOUR-API-KEY')
results = c.desk("Foreign").date("2013-05-26").query("Afghanistan").result # retrieve API results for articles and blog posts mentioning Afghanistan from the Foreign Desk on May 26, 2013:
results.hits
 => 4
article = results.articles.first
=> <Mccandlish::Article:0x007fca04897b20 @id="51a176ad46fdbf6c1db79139", @web_url="http://www.nytimes.com/2013/05/26/world/asia/in-afghan-transition-us-forces-take-a-step-back.html", @snippet="As the United States military moves into a support role in Afghanistan, a week spent with a brigade accompanying Afghan forces offered a direct look at the evolving training mission, for better or for worse.", ... @type_of_material="News", @word_count=1243>
article.headline
=> "In Afghan Transition, U.S. Forces Take a Step Back"
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
