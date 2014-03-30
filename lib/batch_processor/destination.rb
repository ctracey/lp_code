module BatchProcessor
  class Destination

    def initialize(xmldoc)
      @xmldoc = xmldoc
    end

    def atlas_id
      @xmldoc.attribute("atlas_id").value
    end
  end
end
