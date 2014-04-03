module BatchProcessor
  class DestinationHtml

    TEMPLATE_PATH = "templates/destination.eruby"

    def initialize(node)
      @node = node
    end

    def html
      template = Erubis::Eruby.new(File.read(TEMPLATE_PATH))
      template.result(destination_name: @node.node_name, navigation: navigation(@node), content: destination_content)
    end

    def save(path)
      filename = "#{path}/#{@node.atlas_node_id}.html"
      File.open(filename, "w") do |file|
        file.write html
      end
      puts "generated: #{filename}"
    end

    private

    def navigation(node)
      children = node.nodes.map {|child| navigation_item(child)}
      destination_link = navigation_item(node, children)
      parent_navigation = navigation_item(node.parent, [destination_link])

      "<ul class='navigation' style='padding-left:10px'>#{parent_navigation}</ul>"
    end

    def navigation_item(node, sub_navigation=nil)
      sub_nav_html = "<ul class='navigation' style='padding-left:10px'>#{sub_navigation.join}</ul>" unless sub_navigation.nil?
      link = ""
      link = "<a href='./#{node.atlas_node_id}.html'>#{node.node_name}</a>" unless node.nil?
      "<li>#{link}#{sub_nav_html}</li>"
    end

    def destination_content
      xml = File.read("destinations/#{@node.atlas_node_id}.xml")
      xml_doc = Nokogiri::XML(xml)

      [
        parse_main(xml_doc, "Overview", "/destination/introductory/introduction/overview"),
        parse_main(xml_doc, "History", "/destination/history/history/overview"),
        parse_sub(xml_doc, "", "/destination/history/history/history"),
      ].join("</br></br>")
    end

    def parse_main(xml_doc, heading, xpath)
      items = []
      xml_doc.xpath(xpath).each do |item|
        items << item.text.gsub(/\n/, "</br>")
      end

      return "" if items.empty? || items.first.empty?
      "<h1>#{heading}</h1><span>#{items.first}</span>"
    end

    def parse_sub(xml_doc, heading, xpath)
      items = []
      xml_doc.xpath(xpath).each do |item|
        items << item.text.gsub(/\n/, "</br>")
      end

      return "" if items.empty? || items.first.empty?
      "<h3>#{heading}</h3><ul><li>#{items.join('</li><li>')}</li></ul>"
    end

  end
end
