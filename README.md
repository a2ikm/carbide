# Carbide

Carbide is a runtime framework like Rake.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'carbide'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install carbide

## Usage

### Simple

```ruby
class SomeService
  include Carbide::DSL

  def initialize
    task :hello do
      puts "Hello"
    end
    task :world do
      puts "World"
    end
    task :hello_world do
      invoke :hello
      invoke :world
    end
  end

  def hello_world
    invoke :hello_world
  end

  private

  def carbide_manager
    @carbide_manager ||= Carbide::Manager.new
  end
end

SomeService.new.hello_world
#=> Hello
    World
```

### Before and After Hooks

```ruby
task :core do
  puts "Processing core task"
end

before_task :core, :setup do
  puts "Processing setup"
end

after_task :core, :teardown do
  puts "Processing teardown"
end

invoke :core
#=> Processing setup
    Processing core task
    Processing teardown
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/a2ikm/carbide.

