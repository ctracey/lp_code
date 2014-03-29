require 'clamp'

module BatchProcessor

  class CLI < Clamp::Command
    option ["-v", "--version"], :flag, "show version" do
      puts BatchProcessor::VERSION
      exit(0)
    end

    def execute
      puts 'running batch process'
    end
  end

end
