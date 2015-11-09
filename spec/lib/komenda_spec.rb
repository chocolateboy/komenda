require 'spec_helper'

describe Komenda do

  describe '.create' do
    let(:command) { double(:command) }
    let(:options) { double(:options) }
    let(:process_builder) { double(Komenda::ProcessBuilder) }
    let(:process) { double(Komenda::Process) }

    it 'creates and returns a process' do
      expect(Komenda::ProcessBuilder).to receive(:new).once.with(command, options) { process_builder }
      expect(process_builder).to receive(:create).once.with(no_args) { process }

      expect(Komenda.create(command, options)).to eq(process)
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
      expect(process_builder).to receive(:create).once.with(no_args) { process }
      expect(process).to receive(:run).once.with(no_args) { result }

      expect(Komenda.run(command, options)).to eq(result)
    end
  end

end
