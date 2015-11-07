require 'open3'

require 'komenda/process_builder'
require 'komenda/process'
require 'komenda/result'

module Komenda

  # @param [String] command
  # @param [Hash] options
  # @return [Komenda::Result]
  def self.run(command, options = {})
    process_builder = Komenda::ProcessBuilder.new(command, options)
    process = process_builder.start
    process.wait_for
  end

end
