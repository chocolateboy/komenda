Komenda [![Build Status](https://travis-ci.org/cargomedia/komenda.svg)](https://travis-ci.org/cargomedia/komenda)
=======
Komenda is a convenience wrapper around `Open3` to run shell commands in Ruby.

Usage
-----
Run a command:
```ruby
Komenda.run('date')
```

The `run()` method will block until the sub process finished.

It will expose the output and exit status as a `Komenda::Result` value:
```ruby
result = Komenda.run("date")
result.stdout   # => "Tue Nov 26 14:45:03 EST 2013\n"
result.stderr   # => ""
result.output   # => "Tue Nov 26 14:45:03 EST 2013\n" (combined stdout + stderr)
result.status   # => 0
result.success? # => true
result.pid      # => 32157
```

The `run()` method has a second argument `options`, which expects these keys:
- **`env`** (Hash): The environment variables to use. Defaults to the current process' environment.

### Advanced usage
The `build()` method creates a `ProcessBuilder` which can be used to `start()` a process in a separate thread.
To wait for the process to finish `wait_for()` can be used:
```ruby
process_builder = Komenda.build('date')
process = process_builder.start
result = process.wait_for
```

With `ProcessBuilder.on()`, event callbacks can be registered. The callback gets executed when the process writes output:
```ruby
process_builder = Komenda::ProcessBuilder.new('date')
process_builder.on(:stdout) { |output| puts "STDOUT: #{output}" }
process_builder.on(:stderr) { |output| puts "STDERR: #{output}" }
process_builder.on(:output) { |output| puts "Output: #{output}" }
result = process_builder.start.wait_for
```

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

TODO
----
Add options for:
- Passing STDIN
- Making `run()` fail when exit status is not '0'
