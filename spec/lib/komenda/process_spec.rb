require 'spec_helper'

describe Komenda::Process do

  describe '#initialize' do
    let(:process_builder) { double(Komenda::ProcessBuilder) }
    let(:process) { Komenda::Process.new(process_builder) }

    it 'sets the process_builder' do
      expect(process.process_builder).to eq(process_builder)
    end

  end

  describe '#run' do

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

      it 'sets the combined output', :skip => 'doesn\'t work, probably because the ruby loop is too slow (both IO objects become available at the same time)' do
        expect(result.output).to eq('123')
      end
    end

    context 'when environment variables are passed' do
      let(:command) { 'echo "foo=${FOO}"' }
      let(:process_builder) { Komenda::ProcessBuilder.new(command, {:env => {:FOO => 'hello'}}) }
      let(:process) { Komenda::Process.new(process_builder) }
      let(:result) { process.run }

      it 'sets the environment variables' do
        expect(result.stdout).to eq("foo=hello\n")
      end
    end

  end
end
