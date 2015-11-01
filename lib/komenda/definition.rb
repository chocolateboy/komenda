module Komenda
  class Definition

    attr_reader :cmd
    attr_reader :env

    # @param [String] cmd
    # @param [Hash] options
    def initialize(cmd, options = {})
      defaults = {
        :env => ENV.to_hash,
      }
      options = defaults.merge(options)

      @cmd = String(cmd)
      @env = Hash[Hash(options[:env]).map { |k, v| [String(k), String(v)] }]
    end

  end
end
