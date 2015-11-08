module Komenda
  class Process

    attr_reader :output

    include EventEmitter

    # @param [ProcessBuilder] process_builder
    def initialize(process_builder)
      @process_builder = process_builder
      @output = {:stdout => '', :stderr => '', :combined => ''}
      @exit_status = nil
      @thread = nil

      on(:stdout) { |data| @output[:stdout] += data }
      on(:stderr) { |data| @output[:stderr] += data }
      on(:output) { |data| @output[:combined] += data }
      process_builder.events.each do |event|
        on(event[:type], &event[:listener])
      end
    end

    # @return [Thread]
    def start
      raise 'Already started' if is_started?
      @thread = Thread.new { run_process(@process_builder) }
    end

    # @return [Komenda::Result]
    def wait_for
      start unless is_started?
      @thread.join
      result
    end

    # @return [TrueClass, FalseClass]
    def running?
      raise 'Process not started' unless is_started?
      @thread.alive?
    end

    # @return [Komenda::Result]
    def result
      raise 'Process not started' unless is_started?
      raise 'Process not finished' unless is_finished?
      Komenda::Result.new(@output, @exit_status)
    end

    private

    # @return [TrueClass, FalseClass]
    def is_started?
      !@thread.nil?
    end

    # @return [TrueClass, FalseClass]
    def is_finished?
      !@exit_status.nil?
    end

    # @param [ProcessBuilder] process_builder
    def run_process(process_builder)
      begin
        if process_builder.cwd.nil?
          run_popen3(process_builder)
        else
          Dir.chdir(process_builder.cwd) { run_popen3(process_builder) }
        end
      rescue Exception => exception
        emit(:error, exception)
        raise exception
      end
    end

    # @param [ProcessBuilder] process_builder
    def run_popen3(process_builder)
      Open3.popen3(process_builder.env, *process_builder.command) do |stdin, stdout, stderr, wait_thr|
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
            end
          end
        end until streams_read_open.empty?

        @exit_status = wait_thr.value
        emit(:exit, result)
      end
    end

  end
end
