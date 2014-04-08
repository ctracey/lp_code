module BatchProcessor
  class Destination

    def initialize(xmldoc)
      @xmldoc = xmldoc
    end

    def xmldoc
      @xmldoc
    end

    def atlas_id
      @atlas_id = @xmldoc.attribute("atlas_id").value if @atlas_id.nil?
      @atlas_id
    end

  end
end
