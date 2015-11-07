require 'open3'

require 'komenda/process_builder'
require 'komenda/runner'
require 'komenda/result'

module Komenda

  # @param [String] command
  # @param [Hash] options
  # @return [Komenda::Result]
  def self.run(command, options = {})
    process_builder = Komenda::ProcessBuilder.new(command, options)
    runner = Komenda::Runner.new
    runner.run(process_builder)
  end

end
