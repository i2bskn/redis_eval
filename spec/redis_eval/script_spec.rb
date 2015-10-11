require "spec_helper"

describe RedisEval::Script do
  include_context "LuaScriptExample"
  let(:script) { RedisEval::Script.build_from_path(pathname) }
  before(:each) { RedisEval::Script.flush }

  describe ".build_from_path" do
    it {
      expect(RedisEval::Script).to receive(:new).with(string_name, File.read(pathname))
      script
    }

    it {
      expect(script).to be_kind_of(RedisEval::Script)
    }
  end

  describe ".load" do
    it {
      expect {
        RedisEval::Script.load(script.script)
      }.to change { script.exist? }
    }

    it {
      expect(RedisEval::Script.load(script.script)).to eq(Digest::SHA1.hexdigest(script.script))
    }
  end

  describe ".flush" do
    before(:each) { RedisEval::Script.load(script.script) }

    it {
      expect {
        RedisEval::Script.flush
      }.to change { script.exist? }
    }
  end

  describe ".redis" do
    it {
      expect(RedisEval.config).to receive(:redis)
      RedisEval::Script.redis
    }
  end

  describe "#initialize" do
    it { expect(script).to have_attributes(name: string_name) }
    it { expect(script).to have_attributes(script: File.read(pathname)) }
    it { expect(script).to have_attributes(sha: Digest::SHA1.hexdigest(File.read(pathname))) }
  end

  describe "#execute" do
    it { expect(script.execute).to eq("Hello world!") }
    it {
      expect(RedisEval.config.redis).to receive(:evalsha).and_raise(Redis::CommandError, "raise example")
      expect { script.execute }.to raise_error(Redis::CommandError)
    }
  end

  describe "#exist?" do
    it { expect(script.exist?).to be_falsey }

    it {
      RedisEval::Script.load(script.script)
      expect(script.exist?).to be_truthy
    }
  end

  describe "#redis" do
    it {
      expect(RedisEval::Script).to receive(:redis)
      script.redis
    }
  end
end
