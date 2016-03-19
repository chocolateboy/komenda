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

      it 'sets an empty ENV' do
        expect(process_builder.env).to eq({})
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

  describe '#env_final' do
    let(:env_custom) { {} }
    let(:env_original) { { 'FOO' => 'foo1', 'BAR' => 'bar1' } }
    let(:process_builder) { Komenda::ProcessBuilder.new('my command', env: env_custom) }
    before { allow(ENV).to receive(:to_hash).and_return(env_original) }

    it 'returns the original environment' do
      expect(process_builder.env_final).to eq('FOO' => 'foo1', 'BAR' => 'bar1')
    end

    context 'when using Bundler' do
      before { allow(Bundler).to receive(:clean_env).and_return('FOO' => 'foo2', 'BAR' => 'bar2') }

      it 'returns the clean environment of Bundler' do
        expect(process_builder.env_final).to eq('FOO' => 'foo2', 'BAR' => 'bar2')
      end

      context 'when enabling "use_bundler_env"' do
        let(:process_builder) { Komenda::ProcessBuilder.new('my command', env: env_custom, use_bundler_env: true) }

        it 'returns the original environment' do
          expect(process_builder.env_final).to eq('FOO' => 'foo1', 'BAR' => 'bar1')
        end
      end
    end

    context 'when passing additional environment variables' do
      let(:env_custom) { { 'FOO' => 'foo3', 'MEGA' => 'mega3' } }

      it 'merges in the additional variables' do
        expect(process_builder.env_final).to eq('FOO' => 'foo3', 'BAR' => 'bar1', 'MEGA' => 'mega3')
      end
    end
  end
end
