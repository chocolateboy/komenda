require 'spec_helper'

describe Komenda do

  describe '.run' do
    let(:cmd) { double(:cmd) }
    let(:runner) { double(Komenda::Runner) }
    let(:definition) { double(Komenda::Definition) }
    let(:result) { double(Komenda::Result) }

    it 'initializes, runs and returns a new command' do
      expect(Komenda::Runner).to receive(:new).once.with(no_args) { runner }
      expect(Komenda::Definition).to receive(:new).once.with(cmd) { definition }
      expect(runner).to receive(:run).once.with(definition) { result }

      expect(Komenda.run(cmd)).to eq(result)
    end
  end

end
