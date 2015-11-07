require 'spec_helper'

describe Komenda do

  describe '.build' do
    let(:command) { double(:command) }
    let(:options) { double(:options) }
    let(:process_builder) { double(Komenda::ProcessBuilder) }

    it 'creates a process builder' do
      expect(Komenda::ProcessBuilder).to receive(:new).once.with(command, options) { process_builder }

      expect(Komenda.build(command, options)).to eq(process_builder)
    end
  end

  describe '.start_process' do
    let(:command) { double(:command) }
    let(:options) { double(:options) }
    let(:process_builder) { double(Komenda::ProcessBuilder) }
    let(:process) { double(Komenda::Process) }

    it 'creates and starts a process' do
      expect(Komenda::ProcessBuilder).to receive(:new).once.with(command, options) { process_builder }
      expect(process_builder).to receive(:start).once.with(no_args) { process }

      expect(Komenda.start_process(command, options)).to eq(process)
    end
  end

  describe '.run' do
    let(:command) { double(:command) }
    let(:options) { double(:options) }
    let(:process_builder) { double(Komenda::ProcessBuilder) }
    let(:process) { double(Komenda::Process) }
    let(:result) { double(Komenda::Result) }

    it 'creates and runs a process and returns a result' do
      expect(Komenda::ProcessBuilder).to receive(:new).once.with(command, options) { process_builder }
      expect(process_builder).to receive(:start).once.with(no_args) { process }
      expect(process).to receive(:wait_for).once.with(no_args) { result }

      expect(Komenda.run(command, options)).to eq(result)
    end
  end

end
