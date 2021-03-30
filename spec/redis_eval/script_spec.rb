require "spec_helper"

RSpec.describe RedisEval::Script do
  let(:script) { RedisEval::Script.new(script_source, with_load: with_load) }
  let(:script_source) { EXAMPLES[script_name] }
  let(:script_sha) { Digest::SHA1.hexdigest(script_source) }
  let(:script_name) { "script1.lua" }
  let(:with_load) { true }

  before { Redis.current.script(:flush) }

  describe "#initialize" do
    it do
      expect(Redis.current).to receive(:script).with(:load, script_source)
      expect(script.source).to eq(script_source)
      expect(script.sha).to eq(script_sha)
    end

    context "with_load: false" do
      let(:with_load) { false }

      it do
        expect(Redis.current).not_to receive(:script)
        script
      end
    end
  end

  describe "#load" do
    let(:with_load) { false }
    subject { script.load }
    after { subject }

    it { expect(Redis.current).to receive(:script).with(:load, script_source) }
  end

  describe "#exist?" do
    subject { script.exist? }

    it { is_expected.to be_truthy }

    context "with_load: false" do
      let(:with_load) { false }

      it { is_expected.to be_falsey }
    end
  end

  context "#execute" do
    subject { script.execute }

    it { is_expected.to eq(2) }

    context "with_load: false" do
      let(:with_load) { false }

      it do
        expect(Redis.current).to receive(:eval).with(script_source, [], [])
        subject
      end
    end
  end
end
