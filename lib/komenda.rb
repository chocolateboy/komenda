require 'open3'

require 'komenda/process_builder'
require 'komenda/process'
require 'komenda/result'

module Komenda

  # @param [String] command
  # @param [Hash] options
  # @return [Komenda::Result]
  def self.run(command, options = {})
    process = start_process(command, options)
    process.wait_for
  end

  # @param [String] command
  # @param [Hash] options
  # @return [Komenda::Process]
  def self.start_process(command, options = {})
    process_builder = Komenda::ProcessBuilder.new(command, options)
    process_builder.start
  end

end
