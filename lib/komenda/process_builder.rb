module Komenda
  class ProcessBuilder

    attr_reader :command
    attr_reader :env
    attr_reader :events

    # @param [String] command
    # @param [Hash] options
    def initialize(command, options = {})
      defaults = {
        :env => ENV.to_hash,
        :events => {}
      }
      options = defaults.merge(options)

      @command = String(command)
      @env = Hash[options[:env].to_hash.map { |k, v| [String(k), String(v)] }]
      @events = []
      options[:events].each { |type, listener| on(type, &listener) }
    end

    # @param [Symbol] event
    def on(event, &block)
      @events.push({:type => event, :listener => block})
    end

    # @return [Komenda::Process]
    def start
      Komenda::Process.new(self)
    end

  end
end
