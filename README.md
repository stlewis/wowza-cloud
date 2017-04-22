# WowzaCloud 

This gem is a dead-simple wrapper around the [Wowza Streaming Cloud
API]('https://sandbox.cloud.wowza.com/apidocs/v1/'). The quickest way to get
started with this library would be to glance over the Wowza documentation, then
come back here and take a look at some of the examples below.

As it stands right now, I've only implemented the endpoints that I have an
active need for. That means that the feature of the API that _you're_ looking
for may not be here. If that's the case, you've got two options. First, you
could try shooting me a message and asking me to build the feature in. If I've
got time, I'll take care of it for you. Alternatively, I'm all for accepting
pull requests, so feel free to add the feature for yourself.

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

### Accessing basic attributes

All of the return values for a call to `/live_streams/{id}` are made available as
attributes on the `WowzaCloud::Stream` object. So, for instance, if you want to
get the broadcast location for a given stream, you can call:

```ruby
stream.broadcast_location # => "us_west_california"
```

This will get you back the string value that corresponds to that attribute from
the API. This works for all of the keys in the return JSON from the API call.

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

### Working With Schedules

Once again, I'd encourage you to refer to the official Wowza API documentation
for details about the schedule API. As of this writing, this gem only supports
retrieving schedule details and enabling or disabling schedules. Editing,
adding and removing are all unsupported at the moment, so you'll still have to
do that through the Wowza Cloud interface.

In any case, you can retrieve and work with schedules in  much the same way
that you work with streams:

#### Getting a list of schedules

You can get a complete list of all your configured schedules like this:

```ruby
schedules = WowzaCloud::Schedule.all
```

This will return an array of `WowzaCloud::Schedule` instances. 

### Accessing basic attributes

All of the return values for a call to `/schedules/{id}` are made available as
attributes on the `WowzaCloud::Schedule` object. So, for instance, if you want
to get the list of days the schedule runs for, you can call:

```ruby
schedule.recurrence_data # => "sunday,monday,tuesday,wednesday,thursday,friday,saturday"
```

This will get you back the string value that corresponds to that attribute from
the API. This works for all of the keys in the return JSON from the API call.

### Fetching a single schedule

Once you have the ID of the schedule you'd like to retrieve, you can fetch it's
data with the following:

```ruby
schedule = WowzaCloud::Schedule.get_schedule('myscheduleid')
```

This will return an instance of `WowzaCloud::Schedule` that you can then work
with as detailed below.

### Enabling a schedule

You can enable a particular schedule by calling the `enable` method:

```ruby
schedule.enable # => 'enabled'
```

The return value of the enable call is the current status of the stream,
(should be "enabled").

### Disabling a schedule

Conversely, if you want to disable a schedule:

```ruby
schedule.disable # => 'disabled'
```

The return value is the same as for enabling -- the current status of the
schedule.

### Getting schedule status

If you want to know whether a schedule is enabled or disabled, you can find out
by calling the `status` instance method:

```ruby
schedule.status # => 'enabled'
```

### Fetching corresponding streams and schedules

Instances of `WowzaCloud::Stream` have a convenience method `schedule` that
will return `nil` if the Stream does not have an associated schedule, but an
appropriate instance of `WowzaCloud::Schedule` if a schedule does exist.

Similarly, instances of `WowzaCloud::Schedule` have a convenience method
`stream`, which will always return the appropriate instance of
a `WowzaCloud::Stream`.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/stlewis/wowza_cloud.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

