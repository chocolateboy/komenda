require 'open3'

require 'komenda/definition'
require 'komenda/runner'
require 'komenda/result'

module Komenda

  # @param [String] cmd
  # @param [Hash] options
  # @return [Komenda::Result]
  def self.run(cmd, options = {})
    definition = Komenda::Definition.new(cmd, options)
    runner = Komenda::Runner.new
    runner.run(definition)
  end

end
