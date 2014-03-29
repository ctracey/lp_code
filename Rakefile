$LOAD_PATH.push File.expand_path("../lib", __FILE__)
require 'rspec/core/rake_task'
require "batch_processor/version"

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

desc 'run test, build gem and install gem'
task :ci => %w{spec gem:build gem:install}

namespace :gem do

  desc 'build the batch_processor gem'
  task :build do
    print_heading 'Building batch_processor gem'
    `gem build batch_processor.gemspec`
  end

  desc 'install batch_processor gem from local gem file'
  task :install do
    version = BatchProcessor::VERSION
    print_heading "Installing batch_processor gem #{version}"
    `gem install ./batch_processor-#{version}.gem`
  end
end

def print_heading heading
    30.times.each { print '=' }
    puts
    puts heading
end
