require 'open3'
require 'event_emitter'

require 'komenda/process_builder'
require 'komenda/process'
require 'komenda/result'

module Komenda

  # @param [String] command
  # @param [Hash] options
  # @return [Komenda::Process]
  def self.create(command, options = {})
    process_builder = Komenda::ProcessBuilder.new(command, options)
    process_builder.create
  end

  # @param [String] command
  # @param [Hash] options
  # @return [Komenda::Result]
  def self.run(command, options = {})
    process_builder = Komenda::ProcessBuilder.new(command, options)
    process_builder.create.run
  end

end
