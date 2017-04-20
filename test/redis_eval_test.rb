require "test_helper"

class RedisEvalTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::RedisEval::VERSION
  end
end
