require 'spec_helper'

describe Komenda::ProcessBuilder do
  describe '#initialize' do
    let(:command) { 'my command' }

    context 'when passing options' do
      let(:env) { { :foo => 'hello', 'bar' => 12 } }
      let(:cwd) { '/tmp/foo' }
      let(:on_stdout) { proc {} }
      let(:events) { { stdout: on_stdout } }
      let(:process_builder) { Komenda::ProcessBuilder.new(command, env: env, cwd: cwd, events: events) }

      it 'sets the command' do
        expect(process_builder.command).to eq(command)
      end

      it 'coerces and sets the environment' do
        expect(process_builder.env).to eq('foo' => 'hello', 'bar' => '12')
      end

      it 'sets the cwd' do
        expect(process_builder.cwd).to eq(cwd)
      end

      it 'sets events' do
        expect(process_builder.events).to eq(stdout: on_stdout)
      end
    end

    context 'when not passing options' do
      let(:process_builder) { Komenda::ProcessBuilder.new(command) }

      it 'uses the ENV from the current process' do
        expect(process_builder.env).to eq(ENV.to_hash)
      end

      it 'sets an empty CWD' do
        expect(process_builder.cwd).to eq(nil)
      end
    end

    context 'when passing command as an array' do
      let(:command) { %w(my command) }
      let(:process_builder) { Komenda::ProcessBuilder.new(command) }

      it 'sets the command' do
        expect(process_builder.command).to eq(command)
      end
    end
  end

  describe '#create' do
    let(:process_builder) { Komenda::ProcessBuilder.new('my command') }
    let(:process) { double(Komenda::Process) }

    it 'creates a process' do
      expect(Komenda::Process).to receive(:new).once.with(process_builder) { process }
      expect(process_builder.create).to eq(process)
    end
  end
end
