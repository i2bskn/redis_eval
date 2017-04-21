module ScriptLoader
  HELLO_RETURN = "Hello World!"

  def hello_script
    @hello_script ||= SCRIPTS_PATH.join("hello.lua").read
  end

  def hello_script_sha
    @hello_script_sha ||= Digest::SHA1.hexdigest(hello_script)
  end

  def error_script
    @error_script ||= SCRIPTS_PATH.join("error.lua").read
  end
end
