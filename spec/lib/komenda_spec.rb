require 'spec_helper'

describe Komenda do

  describe '.run' do
    let(:command) { double(:command) }
    let(:options) { double(:options) }
    let(:process_builder) { double(Komenda::ProcessBuilder) }
    let(:process) { double(Komenda::Process) }
    let(:result) { double(Komenda::Result) }

    it 'creates and runs a process and returns a result' do
      expect(Komenda::ProcessBuilder).to receive(:new).once.with(command, options) { process_builder }
      expect(Komenda::Process).to receive(:new).once.with(process_builder) { process }
      expect(process).to receive(:wait_for).once.with(no_args) { result }

      expect(Komenda.run(command, options)).to eq(result)
    end
  end

end
