require 'spec_helper'

describe Komenda::Definition do

  describe '#initialize' do
    let(:cmd) { 'my command' }
    let(:definition) { Komenda::Definition.new(cmd) }

    it 'sets the cmd' do
      expect(definition.cmd).to eq(cmd)
    end
  end

end
