RSpec.describe RedisEval::Script do
  it { Redis.current.ping }
end
