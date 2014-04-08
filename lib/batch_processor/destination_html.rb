module BatchProcessor
  class DestinationHtml

    TEMPLATE_PATH = "templates/destination.eruby"

    def initialize(destination, taxonomy)
      @destination = destination
      @taxonomy = taxonomy
    end

    def html
      template = Erubis::Eruby.new(File.read(TEMPLATE_PATH))
      template.result(destination_name: @taxonomy.node_name, navigation: navigation(@taxonomy), content: destination_content)
    end

    def save(path)
      filename = "#{path}/#{@taxonomy.atlas_node_id}.html"
      File.open(filename, "w") do |file|
        file.write html
      end
      puts "generated: #{filename}"
    end

    private

    def navigation(taxonomy)
      children = taxonomy.nodes.map {|child| navigation_item(child)}
      destination_link = navigation_item(taxonomy, children)
      parent_navigation = navigation_item(taxonomy.parent, [destination_link])

      "<ul class='navigation' style='padding-left:10px'>#{parent_navigation}</ul>"
    end

    def navigation_item(taxonomy, sub_navigation=nil)
      sub_nav_html = "<ul class='navigation' style='padding-left:10px'>#{sub_navigation.join}</ul>" unless sub_navigation.nil?
      link = ""
      link = "<a href='./#{taxonomy.atlas_node_id}.html'>#{taxonomy.node_name}</a>" unless taxonomy.nil?
      "<li>#{link}#{sub_nav_html}</li>"
    end

    def destination_content
      xml_doc = @destination.xmldoc

      #update this to modify the content
      [
        parse_main_section(xml_doc, "Overview", "introductory/introduction/overview"),
        parse_main_section(xml_doc, "History", "history/history/overview"),
        parse_sub_section(xml_doc, "", "history/history/history"),
      ].join("</br></br>")
    end

    def parse_main_section(xml_doc, heading, xpath)
      items = []
      xml_doc.xpath(xpath).each do |item|
        items << item.text.gsub(/\n/, "</br>")
      end

      return "" if items.empty? || items.first.empty?
      "<h1>#{heading}</h1><span>#{items.first}</span>"
    end

    def parse_sub_section(xml_doc, heading, xpath)
      items = []
      xml_doc.xpath(xpath).each do |item|
        items << item.text.gsub(/\n/, "</br>")
      end

      return "" if items.empty? || items.first.empty?
      "<h3>#{heading}</h3><ul><li>#{items.join('</li><li>')}</li></ul>"
    end

  end
end
