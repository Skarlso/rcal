require 'bundler'
Bundler::GemHelper.install_tasks

task :setup do
  puts 'Setting up Google integration.'
end

begin
  require 'rspec/core/rake_task'

  RSpec::Core::RakeTask.new(:spec)

  task default: :spec
rescue LoadError => le
  puts "There was a problem loading RSpec. #{le}."
end
