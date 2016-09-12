Komenda
=======
Komenda is a convenience wrapper to run shell commands in Ruby.

[![Build Status](https://img.shields.io/travis/cargomedia/komenda/master.svg)](https://travis-ci.org/cargomedia/komenda)
[![Gem Version](https://img.shields.io/gem/v/komenda.svg)](https://rubygems.org/gems/komenda)

Usage
-----
Run a command:
```ruby
Komenda.run('date')
```

The `run()` method will block until the sub process finished.

It will expose the output and exit status as a `Komenda::Result` value:
```ruby
result = Komenda.run('date')
result.stdout   # => "Tue Nov 26 14:45:03 EST 2013\n"
result.stderr   # => ""
result.output   # => "Tue Nov 26 14:45:03 EST 2013\n" (combined stdout + stderr)
result.status   # => 0
result.success? # => true
result.pid      # => 32157
```
The program and its arguments can be passed as an array:
```ruby
result = Komenda.run(['echo', '-n', 'hello'])
result.output   # => "hello"
```

### Run options
The `run()` method has a second argument `options`.
```ruby
result = Komenda.run('date', fail_on_fail: true)
```


The following options can be configured:
- **`env`** (Hash): Additional environment variables to set.
- **`use_bundler_env`** (Boolean): Use the [environment of the current bundle](http://www.cargomedia.ch/2016/03/18/reset-bundler-environment.html). Defaults to `false`.
- **`cwd`** (String): Directory to change to before running the process.
- **`fail_on_fail`** (Boolean): Whether to raise an error when the exit code is not "0". Defaults to `false`.

### Asynchronous running
The `create()` method creates a `Process` which can be `run()` (or `start()`ed as a Thread).
```
process = Komenda.create('date')
result = process.run
```

Event callbacks can be registered with `Process.on()`, for example for when output is written.
```ruby
process = Komenda.create('date')
process.on(:stdout) { |output| puts "STDOUT: #{output}" }
result = process.run
```
The following events are emitted:
- **`.on(:stdout) { |output| }`**: When data is available on STDOUT.
- **`.on(:stderr) { |output| }`**: When data is available on STDERR.
- **`.on(:output) { |output| }`**: When data is available on STDOUT or STDERR.
- **`.on(:exit) { |result| }`**: When the process finishes.
- **`.on(:error) { |exception| }`**: When process execution fails (e.g. executable file cannot be found).

Development
-----------
Install dependencies:
```
bundle install
```

Run the tests:
```
bundle exec rake spec
```
