module Komenda
  class ProcessBuilder
    attr_reader :command

    attr_reader :env
    attr_reader :use_bundler_env
    attr_reader :cwd
    attr_reader :fail_on_fail
    attr_reader :events

    # @param [String, String[]] command
    # @param [Hash] options
    def initialize(command, options = {})
      defaults = {
        env: {},
        use_bundler_env: false,
        cwd: nil,
        fail_on_fail: false,
        events: {}
      }
      options = defaults.merge(options)

      self.command = command
      self.env = options[:env]
      self.use_bundler_env = options[:use_bundler_env]
      self.cwd = options[:cwd]
      self.fail_on_fail = options[:fail_on_fail]
      self.events = options[:events]
    end

    # @return [Komenda::Process]
    def create
      Komenda::Process.new(self)
    end

    # @param [String, Array<String>] command
    def command=(command)
      @command = if command.is_a?(Array)
                   command.map { |v| String(v) }
                 else
                   String(command)
                 end
    end

    # @param [Hash] env
    def env=(env)
      @env = Hash[env.to_hash.map { |k, v| [String(k), String(v)] }]
    end

    # @param [Boolean] use_bundler_env
    def use_bundler_env=(use_bundler_env)
      @use_bundler_env = use_bundler_env ? true : false
    end

    # @param [String] cwd
    def cwd=(cwd = nil)
      @cwd = cwd.nil? ? nil : String(cwd)
    end

    # @param [Boolean] fail_on_fail
    def fail_on_fail=(fail_on_fail)
      @fail_on_fail = fail_on_fail ? true : false
    end

    # @param [Hash<Symbol, Proc>]
    def events=(events)
      @events = Hash[events.to_hash.map { |k, v| [k.to_sym, v.to_proc] }]
    end

    # @return [Hash]
    def env_final
      env_original = if !use_bundler_env && Object.const_defined?('Bundler')
                       bundler_clean_env
                     else
                       ENV.to_hash
                     end
      env_original.merge(env)
    end

    private

    # @return [Hash]
    def bundler_clean_env
      if Bundler.methods(false).include?(:clean_env)
        Bundler.clean_env
      else
        # For Bundler < 1.12.0
        Bundler.with_clean_env { ENV.to_hash }
      end
    end
  end
end
