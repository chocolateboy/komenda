module Komenda
  class ProcessBuilder

    attr_reader :command
    attr_reader :env

    # @param [String] command
    # @param [Hash] options
    def initialize(command, options = {})
      defaults = {
        :env => ENV.to_hash,
      }
      options = defaults.merge(options)

      @command = String(command)
      @env = Hash[options[:env].to_hash.map { |k, v| [String(k), String(v)] }]
    end

    # @return [Komenda::Process]
    def start
      Komenda::Process.new(self)
    end

  end
end
