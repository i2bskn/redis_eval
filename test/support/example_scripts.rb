module ExampleScripts
  BASE_PATH = Pathname.new(File.expand_path("../scripts", __dir__))

  def all_example_count
    BASE_PATH.children.size
  end

  def one_source
    @one_source ||= ERB.new(BASE_PATH.join("one.lua").read).result
  end

  def one_sha
    @one_sha ||= Digest::SHA1.hexdigest(one_source)
  end

  def error_source
    @error_source ||= ERB.new(BASE_PATH.join("error.lua").read).result
  end
end
