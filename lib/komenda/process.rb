module Komenda
  class Process

    attr_reader :process_builder
    attr_reader :output
    attr_reader :exit_status

    # @param [ProcessBuilder] process_builder
    def initialize(process_builder)
      @process_builder = process_builder
      @output = {:stdout => '', :stderr => '', :combined => ''}
      @exit_status = nil
    end

    # @return [Komenda::Result]
    def run
      Open3.popen3(process_builder.env, process_builder.command) do |stdin, stdout, stderr, wait_thr|
        stdin.close

        streams_read_open = [stdout, stderr]
        begin
          streams_read_available, _, _ = IO.select(streams_read_open)

          streams_read_available.each do |stream|
            if stream.eof?
              stream.close
              streams_read_open.delete(stream)
            else
              data = stream.readpartial(4096)
              @output[:stdout] += data if stdout === stream
              @output[:stderr] += data if stderr === stream
              @output[:combined] += data
            end
          end
        end until streams_read_open.empty?

        @exit_status = wait_thr.value
      end

      Komenda::Result.new(output, exit_status)
    end

  end
end
