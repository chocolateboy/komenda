require 'spec_helper'

describe Komenda::ProcessBuilder do

  describe '#initialize' do
    let(:command) { 'my command' }

    context 'when passing an ENV' do
      let(:process_builder) { Komenda::ProcessBuilder.new(command, {:env => {:foo => 'hello', 'bar' => 12}}) }

      it 'sets the command' do
        expect(process_builder.command).to eq(command)
      end

      it 'coerces and sets the environment' do
        expect(process_builder.env).to eq({'foo' => 'hello', 'bar' => '12'})
      end
    end

    context 'when not passing options' do
      let(:process_builder) { Komenda::ProcessBuilder.new(command) }

      it 'uses the env from the current process' do
        expect(process_builder.env).to eq(ENV.to_hash)
      end
    end
  end

  describe '#start' do
    let(:process_builder) { Komenda::ProcessBuilder.new('my command') }
    let(:process) { double(Komenda::Process) }

    it 'creates a process' do
      expect(Komenda::Process).to receive(:new).once.with(process_builder) { process }
      expect(process_builder.start).to eq(process)
    end
  end

end
