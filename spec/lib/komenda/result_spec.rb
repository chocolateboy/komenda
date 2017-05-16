require 'spec_helper'

describe Komenda::Result do
  describe '#initialize' do
    let(:output) { { stdout: 'my stdout', stderr: 'my stderr', combined: 'my combined output' } }
    let(:status) { double(Process::Status, exitstatus: 12, success?: false, error?: true, pid: 123) }
    let(:result) { Komenda::Result.new(output, status) }

    it 'sets the output' do
      expect(result.stdout).to eq('my stdout')
      expect(result.stderr).to eq('my stderr')
      expect(result.output).to eq('my combined output')
    end

    it 'sets the status' do
      expect(result.exitstatus).to be(12)
    end
  end

  describe '#exitstatus' do
    let(:status) { double(Process::Status, exitstatus: 12) }
    let(:result) { Komenda::Result.new({}, status) }

    it 'returns the exit status' do
      expect(result.exitstatus).to eq(12)
      expect(result.status).to eq(12)
    end
  end

  describe '#success' do
    let(:result) { Komenda::Result.new({}, status) }

    context 'when the exitstatus is 0' do
      let(:status) { double(Process::Status, exitstatus: 0) }

      it 'returns true' do
        expect(result.success?).to eq(true)
      end
    end

    context 'when the exitstatus is 123' do
      let(:status) { double(Process::Status, exitstatus: 123) }

      it 'returns false' do
        expect(result.success?).to eq(false)
      end
    end
  end

  describe '#error' do
    let(:result) { Komenda::Result.new({}, status) }

    context 'when the exitstatus is 0' do
      let(:status) { double(Process::Status, exitstatus: 0) }

      it 'returns false' do
        expect(result.error?).to eq(false)
      end
    end

    context 'when the exitstatus is 123' do
      let(:status) { double(Process::Status, exitstatus: 123) }

      it 'returns true' do
        expect(result.error?).to eq(true)
      end
    end
  end

  describe '#pid' do
    let(:status) { double(Process::Status, pid: 123) }
    let(:result) { Komenda::Result.new({}, status) }

    it 'returns the success' do
      expect(result.pid).to eq(123)
    end
  end
end
