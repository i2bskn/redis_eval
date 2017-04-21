require "test_helper"

class RedisEval::ScriptTest < Minitest::Test
  HELLO = "Hello World!"

  def test_execute_with_initial_load
    script = RedisEval::Script.new(hello_script)
    assert_equal hello_script, script.script
    assert_equal hello_script_sha, script.sha
    assert script.exist?
    assert_equal HELLO, script.execute
  end

  def test_execute_without_initial_load
    Redis.current.script(:flush)
    script = RedisEval::Script.new(hello_script, with_load: false)
    assert_equal hello_script, script.script
    assert_equal hello_script_sha, script.sha
    refute script.exist?
    assert_equal HELLO, script.execute
  end

  def test_execute_and_raise_script_error
    script = RedisEval::Script.new(error_script)
    assert_raises { script.execute }
  end

  def test_redis_connection_switch
    script           = RedisEval::Script.new(hello_script, with_load: false)
    script_set       = create_script_set
    script_set.redis = Redis.new(db: 11)

    assert_equal REDIS_TEST_DB, script.redis.client.db

    script.script_set = script_set
    assert_equal 11, script.redis.client.db

    script.redis = Redis.new(db: 12)
    assert_equal 12, script.redis.client.db
  end

  def test_build_from_script_set
    script_set = create_script_set
    script     = RedisEval::Script.build_from_script_set(hello_script, script_set)

    assert_kind_of RedisEval::Script, script
    assert_equal script_set, script.script_set
  end

  private

    def hello_script
      @hello_script ||= SCRIPTS_PATH.join("hello.lua").read
    end

    def hello_script_sha
      @hello_script_sha ||= Digest::SHA1.hexdigest(hello_script)
    end

    def error_script
      @error_script ||= SCRIPTS_PATH.join("error.lua").read
    end

    def create_script_set
      RedisEval::ScriptSet.new(SCRIPTS_PATH)
    end
end
