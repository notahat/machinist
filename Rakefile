require 'rubygems'
require 'rake'
require 'spec/rake/spectask'
require 'rake/gempackagetask'

$LOAD_PATH.unshift File.dirname(__FILE__) + '/lib'
require 'machinist'

desc 'Default: run specs.'
task :default => :spec

desc 'Run all the specs for the machinist plugin.'
Spec::Rake::SpecTask.new do |t|
  t.spec_files = FileList['spec/**/*_spec.rb']
  t.spec_opts = ['--colour']
  t.rcov = true
end

PKG_NAME           = "machinist"
PKG_VERSION        = Machinist::Version::String
PKG_FILE_NAME      = "#{PKG_NAME}-#{PKG_VERSION}"

spec = Gem::Specification.new do |s|
  s.name              = PKG_NAME
  s.version           = PKG_VERSION
  s.summary           = "Fixtures aren't fun. Machinist is."
  s.description       = "Fixtures aren't fun. Machinist is."
  s.author            = "Pete Yandell"
  s.email             = "pete@notahat.com"
  s.has_rdoc          = false
  s.test_files        = FileList["spec/**/*_spec.rb"]
  s.files             = FileList[
    "lib/**/*.rb",
    "spec/**/*.rb",
    "MIT-LICENSE",
    "README.markdown",
    "init.rb",
    "rails/init.rb"
  ]
end

Rake::GemPackageTask.new(spec) do |p|
  p.gem_spec = spec
  p.need_tar = false
  p.need_zip = false
end
