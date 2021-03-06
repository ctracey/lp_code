require 'nori'

module BatchProcessor
  class Taxonomies
    include Enumerable

    def initialize(hash)
      @data = hash[:taxonomies]
    end

    def self.parse(path)
      begin
        xml = File.read(path)
        parser = Nori.new(convert_tags_to: lambda { |tag| tag.snakecase.to_sym })
        Taxonomies.new(parser.parse(xml))
      rescue Exception => e
        raise "error parsing taxonomy #{path}: #{e.message}"
      end
    end

    def each
      # a single taxonomy will not be parsed by Nori as an array
      taxonomies = @data[:taxonomy]

      if taxonomies.instance_of?(Array)
        taxonomies.each do |taxonomy|
          yield NodeParent.new(taxonomy)
        end
      else
        yield NodeParent.new(taxonomies)
      end
    end

  end
end
