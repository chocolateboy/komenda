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
- **`cwd`** (String): Directory to change to before running the process. Defaults to `nil`.

### Advanced usage
The `create()` method creates a `Process` which can be `start()`ed (in a Thread) or `wait_for()`ed until finished.
Waiting for a process will implicitly start it.
```ruby
process = Komenda.create('date')
thread = process.start
result = process.wait_for
```

Event callbacks can be registered with `Process.on()`, for example for when output is written.
```ruby
process = Komenda.create('date')
process.on(:stdout) { |output| puts "STDOUT: #{output}" }
result = process.wait_for
```
The following events are emitted:
- **`.on(:stdout) { |output| }`**: When data is available on STDOUT
- **`.on(:stderr) { |output| }`**: When data is available on STDERR
- **`.on(:output) { |output| }`**: When data is available on STDOUT or STDERR
- **`.on(:exit) { |result| }`**: When the process finishes
- **`.on(:error) { |exception| }`**: In case execution fails

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
