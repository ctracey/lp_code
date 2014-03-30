module BatchProcessor
  class Destination

    def initialize(xmldoc)
      @xmldoc = xmldoc
    end

    def atlas_id
      @atlas_id = @xmldoc.attribute("atlas_id").value if @atlas_id.nil?
      @atlas_id
    end

    def save(path)
      filename = "#{atlas_id}.xml"
      File.open("#{path}/#{filename}", "w") do |file|
        file.write @xmldoc.to_s
      end

      return filename
    end
  end
end
