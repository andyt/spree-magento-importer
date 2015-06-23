# Spree Magento Importer

Having investigated other avenues (including DataShift::Spree, Wombat), sadly I find myself in the position of writing an importer gem to load data from a Magento CSV export into Spree.


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'spree-magento-importer'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install spree-magento-importer

## Usage

Currently there are working specs with fixtures for a proof-of-concept product importer, but no mechanism for use with a specific Magento export file.


## Contributing

1. Fork it ( https://github.com/[my-github-username]/spree-magento-importer/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
