# AozoraZip

![](https://github.com/takahashim/aozora_zip/workflows/Ruby/badge.svg)


AozoraZip is zip/unzip tool to use archive file (*.zip) in [aozora bunko](https://www.aozora.gr.jp/).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'aozora_zip'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install aozora_zip

## Usage

```
$ aozora_zip zip some
$ aozora_zip zip some --file other.zip
$ aozora_zip unzip some.zip
$ aozora_zip unzip some.zip --dir other
```

## Development

After checking out the repo, run `bundle install` to install dependencies. Then, run `bundle exec rake` to run the tests.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/takahashim/aozora_zip.


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
