require 'open3'

require 'komenda/definition'
require 'komenda/runner'
require 'komenda/result'

module Komenda

  # @param [String] command
  # @param [Hash] options
  # @return [Komenda::Result]
  def self.run(command, options = {})
    definition = Komenda::Definition.new(command, options)
    runner = Komenda::Runner.new
    runner.run(definition)
  end

end
