require 'rubygems'
require 'bundler'
Bundler::GemHelper.install_tasks

require 'rake'
require 'rspec/core/rake_task'
require 'rake/rdoctask'


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
