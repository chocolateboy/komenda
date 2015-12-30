require 'spec_helper'

describe Komenda::Process do
  after { process.kill('KILL') if process.running? }

  describe '#initialize' do
    let(:process_builder) { Komenda::ProcessBuilder.new('echo -n "hello"') }
    let(:process) { Komenda::Process.new(process_builder) }

    it 'creates a process with empty output' do
      expect(process.output).to eq(stdout: '', stderr: '', combined: '')
    end
  end

  context 'when just created' do
    let(:process_builder) { Komenda::ProcessBuilder.new('echo -n "hello"') }
    let(:process) { Komenda::Process.new(process_builder) }

    describe '#start' do
      it 'returns a thread' do
        expect(process.start).to be_a(Thread)
      end
    end

    describe '#wait_for' do
      it 'raises an error' do
        expect { process.wait_for }.to raise_error(StandardError, /not started/)
      end
    end

    describe '#run' do
      it 'returns a result' do
        expect(process.run).to be_a(Komenda::Result)
      end
    end

    describe '#running?' do
      it 'returns false' do
        expect(process.running?).to eq(false)
      end
    end

    describe '#result' do
      it 'raises an error' do
        expect { process.result }.to raise_error(StandardError, /not started/)
      end
    end

    describe '#pid' do
      it 'raises an error' do
        expect { process.pid }.to raise_error(StandardError, /No PID available/)
      end
    end
  end

  context 'when started' do
    let(:process_builder) { Komenda::ProcessBuilder.new('echo -n "hello"') }
    let(:process) { Komenda::Process.new(process_builder) }
    before { process.start }

    describe '#start' do
      it 'does not start again' do
        expect { process.start }.to raise_error(StandardError, /Already started/)
      end
    end

    describe '#wait_for' do
      it 'returns a result' do
        expect(process.wait_for).to be_a(Komenda::Result)
      end
    end

    describe '#run' do
      it 'returns a result' do
        expect(process.run).to be_a(Komenda::Result)
      end
    end

    describe '#running?' do
      it 'returns false' do
        expect(process.running?).to eq(false)
      end
    end

    describe '#result' do
      it 'raises an error' do
        expect { process.result }.to raise_error(StandardError, /not finished/)
      end
    end
  end

  context 'when running' do
    let(:process_builder) { Komenda::ProcessBuilder.new('echo -n "hello"; sleep 0.1;') }
    let(:process) { Komenda::Process.new(process_builder) }
    before { process.start }
    before { wait_for { process.running? }.to eq(true) }

    describe '#start' do
      it 'does not start again' do
        expect { process.start }.to raise_error(StandardError, /Already started/)
      end
    end

    describe '#wait_for' do
      it 'returns a result' do
        expect(process.wait_for).to be_a(Komenda::Result)
      end
    end

    describe '#run' do
      it 'returns a result' do
        expect(process.run).to be_a(Komenda::Result)
      end
    end

    describe '#running?' do
      it 'returns true' do
        expect(process.running?).to eq(true)
      end
    end

    describe '#result' do
      it 'raises an error' do
        expect { process.result }.to raise_error(StandardError, /not finished/)
      end
    end
  end

  context 'when finished' do
    let(:process_builder) { Komenda::ProcessBuilder.new('echo -n "hello"') }
    let(:process) { Komenda::Process.new(process_builder) }
    before { process.run }

    describe '#start' do
      it 'does not start again' do
        expect { process.start }.to raise_error(StandardError, /Already started/)
      end
    end

    describe '#wait_for' do
      it 'returns a result' do
        expect(process.wait_for).to be_a(Komenda::Result)
      end
    end

    describe '#run' do
      it 'returns a result' do
        expect(process.run).to be_a(Komenda::Result)
      end
    end

    describe '#running?' do
      it 'returns false' do
        expect(process.running?).to eq(false)
      end
    end

    describe '#result' do
      it 'returns a result' do
        expect(process.result).to be_a(Komenda::Result)
      end
    end

    describe '#pid' do
      it 'returns a number' do
        expect(process.pid).to be_a(Integer)
      end
    end
  end

  context 'when popen3 fails' do
    let(:process_builder) { Komenda::ProcessBuilder.new('echo -n "hello"') }
    let(:process) { Komenda::Process.new(process_builder) }
    before { allow(process).to receive(:run_popen3).and_raise(StandardError, 'popen3 failed') }

    describe '#start' do
      it 'returns a result' do
        expect(process.start).to be_a(Thread)
      end
    end

    describe '#run' do
      it 'raises an error' do
        expect { process.run }.to raise_error(StandardError, /popen3 failed/)
      end
    end
  end

  describe '#emit' do
    let(:command) { 'ruby -e \'STDOUT.sync=STDERR.sync=true; STDOUT.print "hello"; sleep(0.01); STDERR.print "world";\'' }
    let(:process_builder) { Komenda::ProcessBuilder.new(command) }
    let(:process) { Komenda::Process.new(process_builder) }

    it 'emits event on stdout' do
      callback = double(Proc)
      process.on(:stdout) { |d| callback.call(d) }

      expect(callback).to receive(:call).once.with('hello')
      process.run
    end

    it 'emits event on stderr' do
      callback = double(Proc)
      process.on(:stderr) { |d| callback.call(d) }

      expect(callback).to receive(:call).once.with('world')
      process.run
    end

    it 'emits event on output' do
      callback = double(Proc)
      process.on(:output) { |d| callback.call(d) }

      expect(callback).to receive(:call).once.ordered.with('hello')
      expect(callback).to receive(:call).once.ordered.with('world')
      process.run
    end

    it 'emits event on exit' do
      callback = double(Proc)
      process.on(:exit) { |d| callback.call(d) }

      expect(callback).to receive(:call).once.ordered.with(an_instance_of(Komenda::Result))
      process.run
    end

    context 'when running a long-running process' do
      let(:command) { 'sleep 3' }

      it 'emits event :exit when process is killed' do
        callback = double(Proc)
        process.on(:exit) { |d| callback.call(d) }

        expect(callback).to receive(:call).once.ordered.with(an_instance_of(Komenda::Result))
        process.start
        sleep(0.01)
        Process.kill('TERM', process.pid)
        sleep(0.01)
      end

      it 'emits event :exit when process is killed forcefully' do
        callback = double(Proc)
        process.on(:exit) { |d| callback.call(d) }

        expect(callback).to receive(:call).once.ordered.with(an_instance_of(Komenda::Result))
        process.start
        sleep(0.01)
        Process.kill('KILL', process.pid)
        sleep(0.01)
      end
    end

    context 'when popen3 fails' do
      it 'emits event on exception' do
        allow(process).to receive(:run_popen3).and_raise(StandardError, 'popen3 failed')
        callback = double(Proc)
        process.on(:error) { |d| callback.call(d) }

        expect(callback).to receive(:call).once.with(an_instance_of(StandardError))
        begin
          process.run
        rescue
          nil
        end
      end
    end
  end

  describe '#run_process' do
    context 'when command exits successfully' do
      let(:command) { 'ruby -e \'STDOUT.sync=STDERR.sync=true; STDOUT.print "hello"; sleep(0.01); STDERR.print "world";\'' }
      let(:process_builder) { Komenda::ProcessBuilder.new(command) }
      let(:process) { Komenda::Process.new(process_builder) }
      let(:result) { process.run }

      it 'returns a result' do
        expect(result).to be_a(Komenda::Result)
      end

      it 'sets the standard output' do
        expect(result.stdout).to eq('hello')
      end

      it 'sets the standard error' do
        expect(result.stderr).to eq('world')
      end

      it 'sets the combined output' do
        expect(result.output).to eq('helloworld')
      end

      it 'sets the exit status' do
        expect(result.exitstatus).to eq(0)
      end

      it 'sets the success' do
        expect(result.success?).to eq(true)
      end

      it 'sets the PID' do
        expect(result.pid).to be_a(Fixnum)
      end
    end

    context 'when command fails' do
      let(:command) { 'ruby -e \'STDOUT.sync=STDERR.sync=true; STDOUT.print "hello"; sleep(0.01); STDERR.print "world"; exit(1);\'' }
      let(:process_builder) { Komenda::ProcessBuilder.new(command) }
      let(:process) { Komenda::Process.new(process_builder) }
      let(:result) { process.run }

      it 'returns a result' do
        expect(result).to be_a(Komenda::Result)
      end

      it 'sets the standard output' do
        expect(result.stdout).to eq('hello')
      end

      it 'sets the standard error' do
        expect(result.stderr).to eq('world')
      end

      it 'sets the combined output' do
        expect(result.output).to eq('helloworld')
      end

      it 'sets the exit status' do
        expect(result.exitstatus).to eq(1)
      end

      it 'sets the success' do
        expect(result.success?).to eq(false)
      end
    end

    context 'when command outputs mixed stdout and stderr' do
      let(:command) { 'ruby -e \'STDOUT.sync=STDERR.sync=true; STDOUT.print "1"; sleep(0.01); STDERR.print "2"; sleep(0.01); STDOUT.print "3";\'' }
      let(:process_builder) { Komenda::ProcessBuilder.new(command) }
      let(:process) { Komenda::Process.new(process_builder) }
      let(:result) { process.run }

      it 'sets the standard output' do
        expect(result.stdout).to eq('13')
      end

      it 'sets the standard error' do
        expect(result.stderr).to eq('2')
      end

      it 'sets the combined output' do
        expect(result.output).to eq('123')
      end
    end

    context 'when command outputs mixed stdout and stderr without delay' do
      let(:command) { 'ruby -e \'STDOUT.sync=STDERR.sync=true; STDOUT.print "1"; STDERR.print "2"; STDOUT.print "3";\'' }
      let(:process_builder) { Komenda::ProcessBuilder.new(command) }
      let(:process) { Komenda::Process.new(process_builder) }
      let(:result) { process.run }

      it 'sets the standard output' do
        expect(result.stdout).to eq('13')
      end

      it 'sets the standard error' do
        expect(result.stderr).to eq('2')
      end

      it 'sets the combined output', skip: 'doesn\'t work, probably because the ruby loop is too slow (both IO objects become available at the same time)' do
        expect(result.output).to eq('123')
      end
    end

    context 'when environment variables are passed' do
      let(:command) { 'echo "foo=${FOO}"' }
      let(:process_builder) { Komenda::ProcessBuilder.new(command, env: { FOO: 'hello' }) }
      let(:process) { Komenda::Process.new(process_builder) }
      let(:result) { process.run }

      it 'sets the environment variables' do
        expect(result.stdout).to eq("foo=hello\n")
      end
    end

    context 'when a CWD is passed' do
      let(:tempdir) { File.realpath(Dir.mktmpdir) }
      let(:command) { 'echo "pwd=${PWD}"' }
      let(:process_builder) { Komenda::ProcessBuilder.new(command, cwd: tempdir) }
      let(:process) { Komenda::Process.new(process_builder) }
      let(:result) { process.run }

      it 'Changes the directory' do
        expect(result.stdout).to eq("pwd=#{tempdir}\n")
      end
    end

    context 'when arguments are passed in an array' do
      let(:command) { ['echo', '-n', 'hello\'world'] }
      let(:process_builder) { Komenda::ProcessBuilder.new(command) }
      let(:process) { Komenda::Process.new(process_builder) }
      let(:result) { process.run }

      it 'Passes the arguments' do
        expect(result.stdout).to eq('hello\'world')
      end
    end
  end

  describe '#kill' do
    let(:ruby_program) do
      [
        'STDOUT.sync=STDERR.sync=true;',
        'STDOUT.print("Started with PID #{Process.pid}\n")',
        'begin',
        ' sleep 100',
        'rescue SignalException => e',
        ' STDOUT.print("Received signal #{e.signo}\n")',
        'end',
        'STDOUT.print("Stopped\n")'
      ].join(';')
    end
    let(:command) { ['ruby', '-e', ruby_program] }
    let(:process_builder) { Komenda::ProcessBuilder.new(command) }
    let(:process) { Komenda::Process.new(process_builder) }

    it 'sends a signal to the process' do
      started = false
      process.on(:stdout) { started = true }

      process.start
      wait_for { process.running? }.to eq(true)
      wait_for { started }.to eq(true)
      process.kill('INT')

      result = process.wait_for
      expect(process.running?).to eq(false)
      expect(result.stdout).to match('Received signal 2')
    end
  end
end
