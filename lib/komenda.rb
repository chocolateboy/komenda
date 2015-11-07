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
    process = Komenda::Process.new(process_builder)
    process.wait_for
  end

end
