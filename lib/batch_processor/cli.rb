require 'clamp'
require 'fileutils'
require 'erubis'

module BatchProcessor

  class CLI < Clamp::Command

    OUTPUT_PATH = "./output"
    MAX_BATCHES_DEFAULT = 20

    option ["-v", "--version"], :flag, "show version" do
      puts BatchProcessor::VERSION
      exit(0)
    end

    parameter "DESTINATIONS_PATH", "Path to xml with destinations content"
    parameter "TAXONOMY_PATH", "Path to xml with destination taxonomy"

    parameter "[MAX_BATCHES]", "Optional, maximum number of batch processes to spawn. Defaults to #{MAX_BATCHES_DEFAULT}"

    def max_batches=(max_batches)
      @max_batches = max_batches.to_i
    end

    def max_batches
      @max_batches = MAX_BATCHES_DEFAULT if @max_batches.nil? || @max_batches == 0
      @max_batches
    end

    def execute
      puts "running batch process"
      split_destinations_content(destinations_path)
      process_destinations(taxonomy_path)
    end

    private

    def output_static_resources
      FileUtils.cp_r("templates/static/", "output")
    end

    def process_destinations(taxonomy_path)
      puts "creating new output directory"
      cleanup_directory(OUTPUT_PATH)

      puts "generating static resources"
      output_static_resources

      puts "processing destinations:"
      destinations = []
      taxonomies = Taxonomies.parse(taxonomy_path)
      taxonomies.each do |taxonomy|
        taxonomy.nodes.each do |node|
          destinations = node.destinations
        end
      end

      num_destinations = destinations.size
      puts "found #{num_destinations} destinations"

      Batcher.new(destinations, max_batches).each do |batch|
        process_batch(batch)
      end
    end

    def process_batch(batch)
      batch.each do |node|
        process_destination(node)
      end
    end

    def process_destination(node)
      begin
        output_path = "./output"
        template_path = "./templates/destination.eruby"

        puts node.to_s

        destinationHtml = DestinationHtml.new(node)
        destinationHtml.save(OUTPUT_PATH)
      rescue Exception=> e
        raise "Error processing destination #{node.node_name}: #{e.message}"
      end
    end

    def split_destinations_content(path)
      begin
        cleanup_directory("./destinations/")

        destinations = Destinations.new(path)
        puts "processing destinations:"
        destinations.each do |destination|
          puts "  #{destination.atlas_id}"
          destination.save("./destinations/")
        end
      rescue Exception => e
        raise "Error splitting destinations #{path}: #{e.message}"
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
