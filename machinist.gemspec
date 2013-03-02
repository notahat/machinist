# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "machinist/version"

Gem::Specification.new do |s|
  s.name     = "machinist"
  s.version  = Machinist::VERSION
  s.platform = Gem::Platform::RUBY
  s.authors  = ["Pete Yandell"]
  s.email    = ["pete@notahat.com"]
  s.homepage = "http://github.com/notahat/machinist"
  s.summary  = "Fixtures aren't fun. Machinist is."

  s.rubyforge_project = "machinist"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency "activerecord"
  s.add_development_dependency "mysql"
  s.add_development_dependency "rake"
  s.add_development_dependency "rspec"
  s.add_development_dependency "rdoc"
end
