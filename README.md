# ConfigBitset
- Provides an abstract class that implements utility methods for managing config flags.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'config_bitset', github: 'mnishiguchi/config_bitset', branch: 'master'
```

And then execute:

    $ bundle

## Usage

```rb
# Represents a set of configuration flags for amenities.
class AmenityConfig < ConfigBitset::Base
  define_flag :washer_dryer, 1, "Washer/Dryer"
  define_flag :dishwasher,   2, ""
  define_flag :ac,           4, "A/C"
  define_flag :balcony,      5, ""
  define_flag :fireplace,    6, ""
end

AmenityConfig.list
# => [{:name=>"washer_dryer", :value=>2, :display_name=>"Washer/Dryer"}, {:name=>"dishwasher", :value=>4, :display_name=>"Dishwasher"}, {:name=>"ac", :value=> 16, :display_name=>"A/C"}, {:name=>"balcony", :value=>32, :display_name=>"Balcony"}, {:name=>"fireplace", :value=>64, :display_name=>"Fireplace"}]
config = AmenityConfig.new
#=> #<AmenityConfig:0x00007f83bc3e6858 @state=0>
config.ac?
#=> false
config.ac = true
#=> true
config.ac?
#=> true
config.dishwasher = true
#=> true
config.to_a
#=> [{:name=>"dishwasher", :value=>4, :display_name=>"Dishwasher"}, {:name=>"ac", :value=>16, :display_name=>"A/C"}]
config.to_i
#=> 20
config.to_s
#=> "10100"
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/mnishiguchi/config_bitset.
