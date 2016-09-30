module Komenda
  class Result
    # @param [Hash] output
    # @option output_streams [String] :stdout
    # @option output_streams [String] :stderr
    # @param [Process::Status] status
    def initialize(output, status)
      @output = output
      @status = status
    end

    def stdout
      @output[:stdout]
    end

    def stderr
      @output[:stderr]
    end

    def output
      @output[:combined]
    end

    def exitstatus
      @status.exitstatus
    end

    alias status exitstatus

    def success?
      exitstatus == 0
    end

    def pid
      @status.pid
    end
  end
end
