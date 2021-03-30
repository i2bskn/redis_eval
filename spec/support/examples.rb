SCRIPT_DIR = Pathname.new(File.expand_path("../scripts", __dir__))
EXAMPLES = SCRIPT_DIR.glob("*.lua").each_with_object({}) { |path, obj|
  obj[path.basename.to_s] = ERB.new(path.read, nil, "-").result(__binding__)
}
