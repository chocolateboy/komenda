require 'spec_helper'

describe Komenda do

  describe '.run' do
    let(:command) { double(:command) }
    let(:options) { double(:options) }
    let(:runner) { double(Komenda::Runner) }
    let(:process_builder) { double(Komenda::ProcessBuilder) }
    let(:result) { double(Komenda::Result) }

    it 'initializes, runs and returns a new command' do
      expect(Komenda::Runner).to receive(:new).once.with(no_args) { runner }
      expect(Komenda::ProcessBuilder).to receive(:new).once.with(command, options) { process_builder }
      expect(runner).to receive(:run).once.with(process_builder) { result }

      expect(Komenda.run(command, options)).to eq(result)
    end
  end

end
