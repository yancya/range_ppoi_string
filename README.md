# RangePpoiString

Convert array to range ppoi string. Or range ppoi string to array.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'range_ppoi_string'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install range_ppoi_string

## Usage

```ruby
require 'range_ppoi_string'
using RangePpoiString

s = [1, *3..5, 7, 11].to_s #=> "1,3-5,7,11"
s.to_a #=> ["1", "3", "4", "5", "7", "11"]
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

To release a new version:

1. Bump the version number in `lib/range_ppoi_string/version.rb`
2. Commit the change and push it to `master`
3. Tag the commit `vX.Y.Z` and push the tag: `git tag vX.Y.Z && git push origin vX.Y.Z`

Pushing a `v*` tag triggers `.github/workflows/release.yml`, which builds the gem and publishes it to [rubygems.org](https://rubygems.org) via RubyGems' Trusted Publisher (no API key required) and creates a GitHub Release.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/yancya/range_ppoi_string.

