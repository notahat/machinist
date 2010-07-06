require 'rubygems'
require 'bundler'
Bundler.setup

require 'rake'
require 'rspec/core/rake_task'
require 'rake/rdoctask'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name     = "machinist"
    gem.summary  = "Fixtures aren't fun. Machinist is."
    gem.email    = "pete@notahat.com"
    gem.homepage = "http://github.com/notahat/machinist"
    gem.authors  = ["Pete Yandell"]
    gem.has_rdoc = false
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler not available. Install it with: gem install jeweler"
end


RSpec::Core::RakeTask.new

RSpec::Core::RakeTask.new(:rcov) do |spec|
  spec.rcov = true
  spec.rcov_opts = ['--exclude', 'spec', '--exclude', '.rvm']
end

desc 'Run the specs.'
task :default => :spec


Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'doc'
  rdoc.title    = 'Machinist'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('lib')
end

task :notes do
   system "grep -n -r 'FIXME\\|TODO' lib spec"
end
