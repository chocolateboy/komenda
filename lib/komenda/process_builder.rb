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
        env: ENV.to_hash,
        cwd: nil,
        events: {}
      }
      options = defaults.merge(options)

      self.command = command
      self.env = options[:env]
      self.cwd = options[:cwd]
      self.events = options[:events]
    end

    # @return [Komenda::Process]
    def create
      Komenda::Process.new(self)
    end

    # @param [String, Array<String>] command
    def command=(command)
      if command.is_a?(Array)
        @command = command.map { |v| String(v) }
      else
        @command = String(command)
      end
    end

    # @param [Hash] env
    def env=(env)
      @env = Hash[env.to_hash.map { |k, v| [String(k), String(v)] }]
    end

    # @param [String] cwd
    def cwd=(cwd = nil)
      @cwd = cwd.nil? ? nil : String(cwd)
    end

    # @param [Hash<Symbol, Proc>]
    def events=(events)
      @events = Hash[events.to_hash.map { |k, v| [k.to_sym, v.to_proc] }]
    end
  end
end
