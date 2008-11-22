MACHINIST_SPEC = Gem::Specification.new do |s|
  s.name     = "machinist"
  s.author   = "notahat"
  s.homepage = "http://github.com/notahat/machinist/tree"
  s.version  = "1.0.1"
  s.date     = "2008-11-22"
  s.summary  = "Im in ur specs machining your fixtures"
  s.has_rdoc = true
  s.files    = [
    ".autotest",
    ".gitignore",
		"MIT-LICENSE", 
		"README.markdown",
		"Rakefile", 
		"machinist.gemspec", 
                "init.rb",
		"lib/machinist.rb", 
    "lib/sham.rb"
  ]
  s.test_files = ["spec/machinist_spec.rb", "spec/sham_spec.rb", "spec/spec_helper.rb"]
  s.add_dependency "activesupport"
end
