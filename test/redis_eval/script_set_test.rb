require "test_helper"

class RedisEval::ScriptSetTest < Minitest::Test
  include ScriptLoader

  def setup
    @script_set = RedisEval::ScriptSet.new(SCRIPTS_PATH)
  end

  def test_load
    assert_equal SCRIPTS_PATH, @script_set.path
    assert_nil @script_set.instance_eval { @redis }

    name = "hello"
    @script_set.load(name)
    loaded_scripts = @script_set.send(:loaded_scripts)
    assert loaded_scripts.key?(name)
    assert_equal hello_script, loaded_scripts[name].source
  end

  def test_load_all
    @script_set.load_all
    loaded_scripts = @script_set.send(:loaded_scripts)
    assert_equal 2, loaded_scripts.size
    assert loaded_scripts.key?("hello")
    assert loaded_scripts.key?("error")
  end

  def test_define_script_name_method
    @script_set.load("hello")
    assert @script_set.respond_to?("hello")
    assert @script_set.respond_to?("error")
    refute @script_set.respond_to?("unknown")
    assert_equal hello_script, @script_set.hello.source
    assert_equal error_script, @script_set.error.source
  end
end
