require 'rubygems'
require 'rake'
require 'spec/rake/spectask'
require 'echoe'

desc 'Default: run specs.'
task :default => :spec

desc 'Run all the specs for the machinist plugin.'
Spec::Rake::SpecTask.new do |t|
  t.spec_files = FileList['spec/**/*_spec.rb']
  t.spec_opts = ['--colour']
  t.rcov = true
end

Echoe.new('machinist', '0.1.0') do |p|
  p.description = "Fixtures aren't fun. Machinist is."
  p.url         = "http://github.com/notahat/machinist"
  p.author      = "Pete Yandell"
  p.email       = "pete@notahat.com"
  p.ignore_pattern = ["coverage/*", "pkg/**/*", "spec/*"]
  p.has_rdoc = false
  p.development_dependencies = []
end
