require 'clamp'
require 'fileutils'

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
      cleanup_destinations("./destinations/")

      destinations = Destinations.new(path)
      puts "processing destinations:"
      destinations.each do |destination|
        puts "  #{destination.atlas_id}"
        destination.save("./destinations/")
      end
    end

    def cleanup_destinations(path)
      begin
        FileUtils.remove_dir(path, true) if Dir.exists?(path)
        `mkdir #{path}`
      rescue
        raise "failed to clean destinations directory #{path}"
      end
    end
  end

end
