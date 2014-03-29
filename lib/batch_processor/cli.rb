require 'clamp'

module BatchProcessor

  class CLI < Clamp::Command
    option ["-v", "--version"], :flag, "show version" do
      puts BatchProcessor::VERSION
      exit(0)
    end

    parameter "DESTINATIONS", "path to xml with destinations content"

    def execute
      puts "running batch process"
      split_destinations_content(destinations)
    end

    private

    def split_destinations_content(path)
      puts "processing destinations: #{path}"
    end
  end

end
