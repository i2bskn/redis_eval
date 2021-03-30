require "spec_helper"

RSpec.describe RedisEval do
  it "has a version number" do
    expect(RedisEval::VERSION).not_to be nil
  end
end
