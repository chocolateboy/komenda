module Komenda
  class ProcessBuilder

    attr_reader :command
    attr_reader :env
    attr_reader :cwd
    attr_reader :events

    # @param [String, String[]] command
    # @param [Hash] options
    def initialize(command, options = {})
      defaults = {
        :env => ENV.to_hash,
        :cwd => nil,
        :events => {},
      }
      options = defaults.merge(options)

      @command = command.is_a?(Array) ? command.map { |v| String(v) } : String(command)
      @env = Hash[options[:env].to_hash.map { |k, v| [String(k), String(v)] }]
      @cwd = options[:cwd].nil? ? nil : String(options[:cwd])
      @events = Hash[options[:events].to_hash.map { |k, v| [k.to_sym, v.to_proc] }]
    end

    # @return [Komenda::Process]
    def create
      Komenda::Process.new(self)
    end

  end
end
