require "spec_helper"

describe RedisEval::GeneratorMethods do
  include_context "LuaScriptExample"

  describe "#build" do
    context "Pathname" do
      it {
        expect(RedisEval::Script).to receive(:build_from_path).with(pathname)
        RedisEval.build(pathname)
      }
    end

    context "String" do
      let(:path) { Pathname.new(string_path) }

      before(:each) {
        expect(RedisEval::Script).to receive(:build_from_path).with(path)
      }

      it {
        expect(RedisEval).to receive(:pathname).with(string_path).and_return(path)
        RedisEval.build(string_path)
      }

      it {
        expect(RedisEval).to receive(:script_path).with(string_name).and_return(path)
        RedisEval.build(string_name)
      }
    end

    context "ArgumentError" do
      it {
        expect {
          RedisEval.build(1)
        }.to raise_error(ArgumentError)
      }
    end
  end

  describe "#pathname" do
    it { expect(RedisEval.send(:pathname, pathname)).to be_kind_of(Pathname) }
    it { expect(RedisEval.send(:pathname, string_path)).to be_kind_of(Pathname) }
  end

  describe "#script_cache" do
    it { expect(RedisEval.send(:script_cache)).to be_kind_of(Hash) }
    it { expect(RedisEval.send(:script_cache)).to be_empty }
  end

  describe "#script_path" do
    it {
      RedisEval.config.reset
      expect(RedisEval.send(:script_path, :hello)).to be_nil
    }

    it {
      RedisEval.config.script_paths = LUA_SCRIPT_PATH
      expect(RedisEval.send(:script_path, :hello)).to eq(pathname)
    }
  end

  describe "#method_missing" do
    before(:each) { RedisEval.config.script_paths = LUA_SCRIPT_PATH }

    it { expect(RedisEval.respond_to?(:hello)).to be_truthy }
    it { expect(RedisEval.respond_to?(:unknown)).to be_falsey }

    it {
      expect(RedisEval).to receive(:build).with(:hello)
      RedisEval.hello
    }
  end
end
