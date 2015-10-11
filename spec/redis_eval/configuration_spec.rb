require "spec_helper"

describe RedisEval::Configuration do
  let(:paths) { ["/path/to/script_dir"] }
  let(:options) { {url: "redis://localhost:6380/0"} }
  let(:config) { RedisEval.config }

  describe "Accessible" do
    context "extended" do
      subject { Module.new { extend RedisEval::Configuration::Accessible } }

      it { is_expected.to respond_to(:configure) }
      it { is_expected.to respond_to(:config) }
    end

    describe "#configure" do
      before do
        RedisEval.configure do |config|
          config.redis_options = options
          config.script_paths = paths
        end
      end

      subject { config }

      it { is_expected.to have_attributes(redis_options: options) }
      it { is_expected.to have_attributes(script_paths: paths) }

      it {
        expect {
          RedisEval.configure {|config| config.unknown = :value }
        }.to raise_error(NoMethodError)
      }
    end

    describe "#config" do
      it { expect(RedisEval.config.is_a?(RedisEval::Configuration)).to be_truthy }
    end
	end

  describe "#initialize" do
    subject { RedisEval.config }

    RedisEval::Configuration::VALID_OPTIONS.each do |key|
      it { is_expected.to respond_to(key) }
    end

    it { is_expected.to have_attributes(redis_options: nil) }
    it { is_expected.to have_attributes(script_paths: []) }
  end

  describe "#redis" do
    after(:each) { config.remove_instance_variable(:@_redis) }

    it { expect(config.redis).to be_kind_of(Redis) }

    it {
      expect(config).to receive(:generate_redis_connection!)
      config.redis
    }
  end

  describe "#merge" do
    subject { config.merge(script_paths: paths) }

    it { is_expected.to have_attributes(script_paths: paths) }
    it { is_expected.to be_kind_of(RedisEval::Configuration) }
	end

  describe "#merge!" do
    subject { config.merge!(script_paths: paths) }

    it { is_expected.to have_attributes(script_paths: paths) }
    it { is_expected.to be_kind_of(RedisEval::Configuration) }
  end

  describe "#generate_redis_connection!" do
    context "when redis_options is nil" do
      it { expect(config.send(:generate_redis_connection!)).to be_kind_of(Redis) }

      it {
        expect(Redis).not_to receive(:new)
        expect(Redis).to receive(:current)
        config.redis
      }
    end

    context "when redis_options is not nil" do
      before { config.redis_options = options }

      it { expect(config.send(:generate_redis_connection!)).to be_kind_of(Redis) }

      it {
        expect(Redis).to receive(:new)
        expect(Redis).not_to receive(:current)
        config.redis
      }
    end
  end
end
