require 'spec_helper'

describe Komenda::Definition do

  describe '#initialize' do
    let(:cmd) { 'my command' }

    context 'when passing an ENV' do
      let(:definition) { Komenda::Definition.new(cmd, {:env => {:foo => 'hello', 'bar' => 12}}) }

      it 'sets the cmd' do
        expect(definition.cmd).to eq(cmd)
      end

      it 'coerces and sets the environment' do
        expect(definition.env).to eq({'foo' => 'hello', 'bar' => '12'})
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
