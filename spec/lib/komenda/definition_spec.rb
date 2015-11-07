require 'spec_helper'

describe Komenda::Definition do

  describe '#initialize' do
    let(:command) { 'my command' }

    context 'when passing an ENV' do
      let(:definition) { Komenda::Definition.new(command, {:env => {:foo => 'hello', 'bar' => 12}}) }

      it 'sets the command' do
        expect(definition.command).to eq(command)
      end

      it 'coerces and sets the environment' do
        expect(definition.env).to eq({'foo' => 'hello', 'bar' => '12'})
      end
    end

    context 'when not passing options' do
      let(:definition) { Komenda::Definition.new(command) }

      it 'uses the env from the current process' do
        expect(definition.env).to eq(ENV.to_hash)
      end
    end
  end

end
