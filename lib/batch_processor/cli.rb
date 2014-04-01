require 'clamp'
require 'fileutils'

module BatchProcessor

  class CLI < Clamp::Command
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
        process_destination(destination)
      end
    end

    private

    def process_destinations(taxonomy_path)
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
      #spec process to handle node (parent)
      pn = node.parent.node_name unless node.parent.nil?
      p "#{node.nodes.size} - #{pn}/#{node.node_name}(#{node.atlas_node_id})"

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
        cleanup_destinations("./destinations/")

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
