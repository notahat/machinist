require 'rake'

require 'spec/rake/spectask'
# require 'rspec/core/rake_task'

# RSpec::Core::RakeTask.new
Spec::Rake::SpecTask.new

# RSpec::Core::RakeTask.new(:rcov) do |spec|
Spec::Rake::SpecTask.new(:rcov) do |spec|
  spec.rcov = true
  # FIXME: Excluding my .rvm directory manually? Nuh uh.
  spec.rcov_opts = ['--exclude', '/Users/pete/.rvm', '--exclude', 'spec']
end

desc 'Run the specs.'
task :default => :spec

require 'rake/rdoctask'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'doc'
  rdoc.title    = 'Machinist'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('lib/**/*.rb')
end

task :notes do
   system "grep -n 'FIXME\\|TODO' lib/**/*.rb spec/**/*.rb"
end
