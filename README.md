# WowzaCloud 

This gem is a dead-simple wrapper around the [Wowza Streaming Cloud
API]('https://sandbox.cloud.wowza.com/apidocs/v1/'). The quickest way to get
started with this library would be to glance over the Wowza documentation, then
come back here and take a look at some of the examples below.

Thus far, this only covers the live streams portion of the API, and is missing
delete, create and update from that section. I'm planning on adding more
functionality as I need it, but feel free to add a pull request if there's
something missing here that you'd like to see.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'wowza_cloud'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install wowza_cloud

## Usage

### Configuration 

Before you can use the Wowza Streaming Cloud API, you'll need to get an API key
and an Access key from Wowza. You can do so through your account settings. Once
you have them, you'll need to provide them to the gem, via a configuration
block. For Rails users, your best bet is to create a `wowza-cloud.rb` file in
your `config/initializers/` directory, then place something like the below in
it:

```ruby
WowzaCloud.configure do |config|
  yaml_path         = `path/to_file/containing/credentials.yml`
  hsh               = YAML.load(File.read(yaml_path))
  config.api_key    = hsh['api_key']
  config.access_key = hsh['access_key']
end
```

For non-Rails users, some variation of the above called somewhere before you
start using the gem should do.

### Getting a list of streams

One of the more basic things you'll want to do is to get a list of all of your
streams. Doing so is as simple as:

```ruby
streams = WowzaCloud::Stream.all
```

The above will return an array of `Wowza::Stream` objects, which you can use to
manipulate individual streams.

### Fetching a single stream

If you have a specific stream you need to work with, you can pull it by itself,
using it's ID:

```ruby
stream = WowzaCloud::Stream.get_stream('vxy4nprl')
```

The above will return a single instance of `Wowza::Stream` that you can use to
manipulate that particular stream.

### Working with a Stream

The gem gives you a number of basic actions you can take for a particular
stream.

#### Checking Stream Status

You can get the status, (also called state), of a stream by calling the
`status` method on a WowzaCloud::Stream instance:

```ruby
stream = WowzaCloud::Stream.get_stream('vxy4nprl')
stream.status # => 'started'
```

The method above will return a string representing the status of the stream,
Possible return states are: starting, stopping, started, stopped, and
resetting.

#### Getting stream statistics 

You can get a hash of stream-related statistics. This is important for
monitoring and reporting purposes:

```ruby
stream = WowzaCloud::Stream.get_stream('vxy4nprl')
stream.stats # => {...}
```

#### Starting, Stopping, and Resetting a Stream

You can manipulate the state of a stream with a few simple commands. Each of
the commands below return a string representing the state of the stream after
your call was made. For instance, if you were to stop a running stream, the
return value of the call would be "stopping":

```ruby
stream = WowzaCloud::Stream.get_stream('vxy4nprl')
# Start a stream
stream.start # => 'starting'
# Reset a stream
stream.reset # => 'resetting'
# Stop a stream
stream.stop # => 'stopping'
```


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/wowza_cloud.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

