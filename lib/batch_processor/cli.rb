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
      destinations = Destinations.new(path)
      puts "processing destinations:"
      destinations.each do |destination|
        title = destination.attribute("title").value
        puts "  #{title}"
      end
    end
  end

end
