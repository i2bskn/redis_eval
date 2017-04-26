require "test_helper"

class RedisEval::ScriptSetTest < Minitest::Test
  include ExampleScripts

  def setup
    @script_set = RedisEval::ScriptSet.new(BASE_PATH)
  end

  def test_load
    assert_equal BASE_PATH, @script_set.path
    assert_nil @script_set.instance_eval { @redis }

    name = "one"
    @script_set.load(name)
    loaded_scripts = @script_set.send(:loaded_scripts)
    assert loaded_scripts.key?(name)
    assert_equal one_source, loaded_scripts[name].source
  end

  def test_load_all
    @script_set.load_all
    loaded_scripts = @script_set.send(:loaded_scripts)
    assert_equal all_example_count, loaded_scripts.size
    assert loaded_scripts.key?("one")
    assert loaded_scripts.key?("error")
  end

  def test_define_script_name_method
    @script_set.load("one")
    assert @script_set.respond_to?("one")
    assert @script_set.respond_to?("error")
    refute @script_set.respond_to?("unknown")
    assert_equal one_source, @script_set.one.source
    assert_equal error_source, @script_set.error.source
  end
end
