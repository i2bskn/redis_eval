shared_context "ConfigurationExample" do
  let(:paths) { ["/path/to/script_dir"] }
  let(:options) { {url: TEST_DB} }
  let(:config) { RedisEval.config }
end

shared_context "LuaScriptExample" do
  let(:string_path) { File.join(LUA_SCRIPT_PATH, "hello.lua") }
  let(:pathname) { Pathname.new(string_path) }
  let(:string_name) { "hello" }
end
