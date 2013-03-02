require 'rubygems'
require 'bundler'
Bundler::GemHelper.install_tasks

require 'rake'
require 'rspec/core/rake_task'
require 'rdoc/task'


RSpec::Core::RakeTask.new(:spec)

desc 'Run the specs.'
task :default => :spec


RDoc::Task.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'doc'
  rdoc.title    = 'Machinist'
  rdoc.options << '--line-numbers'
  rdoc.rdoc_files.include('lib')
end

task :notes do
   system "grep -n -r 'FIXME\\|TODO' lib spec"
end
