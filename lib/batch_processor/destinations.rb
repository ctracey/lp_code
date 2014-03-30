module BatchProcessor

  class Destinations

    def initialize(path)
      @path = path
    end

    def each
      begin
        file = File.open(@path)
        xmldoc = Nokogiri::XML(file) do |config|
          config.options = Nokogiri::XML::ParseOptions::NOBLANKS && Nokogiri::XML::ParseOptions::RECOVER
        end

        errors = xmldoc.errors.map(&:to_s).join(", ")
        raise "Error parsing #{@path}: #{errors}" unless xmldoc.errors.empty?

        xmldoc.xpath("/destinations/destination").each do |destination|
          yield destination
        end
      ensure
        file.close
      end

    end

  end

end
