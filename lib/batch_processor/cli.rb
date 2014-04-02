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

    parameter "DESTINATIONS_PATH", "path to xml with destinations content"
    parameter "TAXONOMY_PATH", "path to xml with destination taxonomy"

    def execute
      puts "running batch process"
      split_destinations_content(destinations_path)
      process_destinations(taxonomy_path) do |destination|
        puts destination.to_s
        process_destination(destination)
      end
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
      taxonomies = Taxonomies.parse(taxonomy_path)
      taxonomies.each do |taxonomy|
        taxonomy.nodes.each do |node|
          node.destinations do |destination|
            yield destination
          end
        end
      end
    end

    def process_destination(node)
      begin
        output_path = "./output"
        template_path = "./templates/destination.eruby"

        destinationHtml = DestinationHtml.new(node.node_name, node.atlas_node_id)
        destinationHtml.save(OUTPUT_PATH)
      rescue Exception=> e
        raise "Error processing destination #{node.node_name}: #{e.message}"
      end
      #spec process to handle node (parent)

      # job = fork do
      #   #do processing stuff
      # end
      # Process.detach(job)


      # html = Nokogiri::HTML(html_text)
      # html.xpath("//h1").each { |div|  div.name= "p"; div.set_attribute("class" , "title") }
      # html.to_html or html.to_s or something like that
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
