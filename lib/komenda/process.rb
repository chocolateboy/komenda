module Komenda
  class Process

    attr_reader :output
    attr_reader :exit_status

    include EventEmitter

    # @param [ProcessBuilder] process_builder
    def initialize(process_builder)
      @output = {:stdout => '', :stderr => '', :combined => ''}
      @exit_status = nil

      process_builder.events.each do |event|
        on(event[:type], &event[:listener])
      end

      @thread = Thread.new { run_process(process_builder) }
      @thread.abort_on_exception = true
    end

    # @return [Komenda::Result]
    def wait_for
      @thread.join
      Komenda::Result.new(output, exit_status)
    end

    # @return [TrueClass, FalseClass]
    def running?
      @thread.alive?
    end

    private

    # @param [ProcessBuilder] process_builder
    def run_process(process_builder)
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
              emit(:stdout, data) if stdout === stream
              emit(:stderr, data) if stderr === stream
              emit(:output, data)

              @output[:stdout] += data if stdout === stream
              @output[:stderr] += data if stderr === stream
              @output[:combined] += data
            end
          end
        end until streams_read_open.empty?

        @exit_status = wait_thr.value
      end
    end

  end
end
