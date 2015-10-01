# Carbide

[![Build Status](https://travis-ci.org/a2ikm/carbide.svg)](https://travis-ci.org/a2ikm/carbide)

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
  include Carbide
  carbide

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

before :core, :setup do
  puts "Processing setup"
end

after :core, :teardown do
  puts "Processing teardown"
end

invoke :core
#=> Processing setup
    Processing core task
    Processing teardown
```

### Options

#### :manager option

You can specify `Carbide::Manager`'s name with `:manager` option like:

```ruby
class SomeClass
  include Carbide
  carbide manager: :fantastic_manager

  def fantastic_manager
    @manager ||= Carbide::Manager
  end
end
```

You can use an instance variable like:

```ruby
class SomeClass
  include Carbide
  carbide manager: :@carbide_manager

  def initialize
    @carbide_manager = Carbide::Manager.new
  end
end
```

#### :prefix option

You can specify DSL methods' prefix with `:prefix` option like:

```ruby
class SomeClass
  include Carbide
  carbide prefix: :foo

  def define_tasks
    foo_task :my_task1
    foo_before :my_task1, :my_task2
    foo_after :my_task1, :my_task3
  end

  def carbide_manager
    @carbide_manager ||= Carbide::Manager.new
  end
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/a2ikm/carbide.

