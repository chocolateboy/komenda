require 'open3'

require 'komenda/definition'
require 'komenda/runner'
require 'komenda/result'

module Komenda

  # @param [String] cmd
  # @return [Komenda::Result]
  def self.run(cmd)
    definition = Komenda::Definition.new(cmd)
    runner = Komenda::Runner.new
    runner.run(definition)
  end

end
