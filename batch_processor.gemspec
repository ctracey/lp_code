$LOAD_PATH.push File.expand_path("../lib", __FILE__)
require 'batch_processor/version'

Gem::Specification.new do |gem|
  gem.name        = "batch_processor"
  gem.description = "gem for the sake of it"
  gem.version     = BatchProcessor::VERSION
  gem.authors     = ["ctracey"]
  gem.email       = ["tracey.chris@gmail.com"]
  gem.homepage    = "https://github.com/ctracey/batch_processor"
  gem.summary     = %q{Batch Processor}

  gem.files         = Dir.glob("**/*")
  gem.test_files    = Dir.glob("{spec}/**/*")
  gem.executables   = Dir.glob("{bin}/*").map{ |file_path| File.basename(file_path) }
  gem.require_paths = ["lib"]

  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'byebug'

  gem.add_runtime_dependency "clamp"
  gem.add_runtime_dependency "nokogiri"
  gem.add_runtime_dependency "nori"
  gem.add_runtime_dependency "erubis"

end
