require 'spec_helper'

describe Komenda::Definition do

  describe '#initialize' do
    let(:cmd) { 'my command' }

    context 'when passing an ENV' do
      let(:definition) { Komenda::Definition.new(cmd, {:env => {:foo => 'bar'}}) }

      it 'sets the cmd' do
        expect(definition.cmd).to eq(cmd)
      end

      it 'sets the environment' do
        expect(definition.env).to eq({:foo => 'bar'})
      end
    end

    context 'when not passing options' do
      let(:definition) { Komenda::Definition.new(cmd) }

      it 'uses the env from the current process' do
        expect(definition.env).to eq(ENV.to_hash)
      end
    end
  end

end
