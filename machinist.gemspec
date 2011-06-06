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
  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rake"
  s.add_development_dependency "rcov"
  s.add_development_dependency "rspec", "~>2.0"

  dm_version = "~>1.1.0"
  s.add_development_dependency 'dm-core',           dm_version
  s.add_development_dependency 'dm-sqlite-adapter', dm_version
  s.add_development_dependency 'dm-transactions',   dm_version
  s.add_development_dependency 'dm-migrations',     dm_version
  s.add_development_dependency 'dm-validations',    dm_version

end
