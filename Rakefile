require 'rake'
require 'rake/gempackagetask'
require 'rake/clean'
require 'spec/rake/spectask'

desc 'Default: run specs.'
task :default => :spec

desc 'Run all the specs for the machinist plugin.'
Spec::Rake::SpecTask.new do |t|
  t.spec_files = FileList['spec/**/*_spec.rb']
  t.rcov = false
end

spec = eval(File.read(File.join(File.dirname(__FILE__), 'machinist.gemspec')))

Rake::GemPackageTask.new(spec) do |pkg|
  pkg.need_zip = true
  pkg.need_tar = true
end
