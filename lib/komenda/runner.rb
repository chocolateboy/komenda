module Komenda
  class Runner

    # @param [Komenda::ProcessBuilder] process_builder
    # @return [Komenda::Result]
    def run(process_builder)
      output = {:stdout => '', :stderr => '', :combined => ''}
      status = nil

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
              output[:stdout] += data if stdout === stream
              output[:stderr] += data if stderr === stream
              output[:combined] += data
            end
          end
        end until streams_read_open.empty?

        status = wait_thr.value
      end

      Komenda::Result.new(output, status)
    end

  end
end
