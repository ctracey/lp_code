require 'clamp'
require 'fileutils'
require 'erubis'

module BatchProcessor

  class CLI < Clamp::Command

    OUTPUT_PATH = "./output"

    option ["-v", "--version"], :flag, "show version" do
      puts BatchProcessor::VERSION
      exit(0)
    end

    parameter "DESTINATIONS_PATH", "Path to xml with destinations content"
    parameter "TAXONOMY_PATH", "Path to xml with destination taxonomy"

    def execute
      puts "running batch process"
      process_destinations
    end

    private

    def output_static_resources
      FileUtils.cp_r("templates/static/", "output")
    end

    def process_destinations
      puts "creating new output directory"
      cleanup_directory(OUTPUT_PATH)

      puts "generating static resources"
      output_static_resources

      puts "processing destinations:"
      puts "parsing taxonomy"
      destination_taxonomy = parse_taxonomy

      puts "found #{destination_taxonomy.size} destinations"

      puts "generating html"
      destinations = Destinations.new(destinations_path)
      destinations.each do |destination|
        process_destination(destination, destination_taxonomy[destination.atlas_id])
      end
    end

    def parse_taxonomy
      destination_taxonomy = {}

      taxonomies = Taxonomies.parse(taxonomy_path)
      taxonomies.each do |taxonomy|
        taxonomy.nodes.each do |node|
          node.destinations.each do |destination|
            destination_taxonomy[destination.atlas_node_id] = destination
          end
        end
      end

      destination_taxonomy
    end

    def process_destination(destination, taxonomy)
      begin
        output_path = "./output"
        template_path = "./templates/destination.eruby"

        puts taxonomy.to_s

        destinationHtml = DestinationHtml.new(destination, taxonomy)
        destinationHtml.save(OUTPUT_PATH)
      rescue Exception=> e
        raise "Error processing destination #{node.node_name}: #{e.message}"
      end
    end

    def cleanup_directory(path)
      begin
        FileUtils.remove_dir(path, true) if Dir.exists?(path)
        FileUtils.mkdir path
      rescue
        raise "failed to clean directory #{path}"
      end
    end
  end

end
