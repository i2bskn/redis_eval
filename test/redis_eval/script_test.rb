require "test_helper"

class RedisEval::ScriptTest < Minitest::Test
  include ExampleScripts

  def test_execute_with_initial_load
    script = one_script
    assert_equal one_source, script.source
    assert_equal one_sha, script.sha
    assert script.exist?
    assert_equal 1, script.execute
  end

  def test_execute_without_initial_load
    Redis.current.script(:flush)
    script = one_script(false)
    assert_equal one_source, script.source
    assert_equal one_sha, script.sha
    refute script.exist?
    assert_equal 1, script.execute
  end

  def test_execute_and_raise_script_error
    script = RedisEval::Script.new(error_source)
    assert_raises(Redis::CommandError) { script.execute }
  end

  def test_switch_redis_connections
    script           = one_script(false)
    script_set       = create_script_set
    script_set.redis = Redis.new(db: DATABASES[:second])

    assert_equal DATABASES[:default], script.redis.client.db

    script.parent = script_set
    assert_equal DATABASES[:second], script.redis.client.db

    script.redis = Redis.new(db: DATABASES[:third])
    assert_equal DATABASES[:third], script.redis.client.db
  end

  def test_build_from_parent
    script_set = create_script_set
    script     = RedisEval::Script.build_from_parent(one_source, script_set)

    assert_kind_of RedisEval::Script, script
    assert_equal script_set, script.parent
  end

  private

    def one_script(with_load = true)
      RedisEval::Script.new(one_source, with_load: with_load)
    end

    def create_script_set
      RedisEval::ScriptSet.new(BASE_PATH)
    end
end
