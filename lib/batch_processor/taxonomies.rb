require 'nori'

module BatchProcessor
  class Taxonomies
    include Enumerable

    def initialize(hash)
      @data = hash[:taxonomies]
    end

    def self.parse(xml)
      parser = Nori.new(convert_tags_to: lambda { |tag| tag.snakecase.to_sym })
      Taxonomies.new(parser.parse(xml))
    end

    def each
      # a single taxonomy will not be parsed as an array
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
