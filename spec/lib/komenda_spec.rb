require 'spec_helper'

describe Komenda do

  describe '.run' do
    let(:command) { double(:command) }
    let(:options) { double(:options) }
    let(:process) { double(Komenda::Process) }
    let(:process_builder) { double(Komenda::ProcessBuilder) }
    let(:result) { double(Komenda::Result) }

    it 'initializes, runs and returns a new command' do
      expect(Komenda::Process).to receive(:new).once.with(no_args) { process }
      expect(Komenda::ProcessBuilder).to receive(:new).once.with(command, options) { process_builder }
      expect(process).to receive(:run).once.with(process_builder) { result }

      expect(Komenda.run(command, options)).to eq(result)
    end
  end

end
