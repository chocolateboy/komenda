require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

task default: :spec

require './lib/komenda'
task :foo do
  command = 'ruby -e \'STDOUT.sync=STDERR.sync=true; STDOUT.print "stdout1"; sleep(0.01); STDOUT.print "stdout2"; sleep(0.01); STDERR.print "stderr1";\''
  command = 'dfgojdfg'
  process = Komenda.create(command)
  process.on(:exit) do |result|
    puts result.exitstatus
    puts result.output
  end
  process.on(:error) do |exception|
    puts 'error'
    puts exception
  end
  # process.start

  # sleep 1
  # sleep 0.1
  result = process.wait_for
  puts 'finished'

end
