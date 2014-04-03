require 'spec_helper'
require 'Erubis'

describe "BatchProcessor::DestinationHTML" do

  let(:node) { double(:node, node_name:"Africa", atlas_node_id: "12345") }
  let(:destinationHtml) { BatchProcessor::DestinationHtml.new(node) }

  describe "#html" do
    let(:template) { double(:template) }
    let(:navigation) { "NAV" }

    before do
      Erubis::Eruby.stub(:new) { template }
      destinationHtml.stub(:destination_content) { "COOL STUFF" }
      destinationHtml.stub(:navigation) { navigation }
    end

    it "generates html with the destination name" do
      template.should_receive(:result) { "html" }
      destinationHtml.html.should == "html"
    end

    it "generates html with the destination content" do
      template.stub(:destination_content) { "COOL STUFF" }
      template.should_receive(:result).with(destination_name: "Africa", navigation: navigation, content: "COOL STUFF")
      destinationHtml.html
    end

    it "generates html with the destination navigation" do
      destinationHtml.should_receive(:navigation)
      template.stub(:result)
      destinationHtml.html
    end

  end

  describe "#navigation" do
    let(:child1) { double(:node, node_name: "Kruger National Park", atlas_node_id: "33333", parent: node) }
    let(:child2) { double(:node, node_name: "Drakensburg", atlas_node_id: "44444", parent: node) }
    let(:node_parent) { double(:node, node_name: "Africa", atlas_node_id: "11111", parent: nil) }
    let(:node) { double(:node, node_name: "South Africa", atlas_node_id: "22222", parent: node_parent) }

    it "returns the navigation html" do
      node.stub(:nodes) { [child1, child2] }
      destination_link = "<a href='./#{node.atlas_node_id}.html'>#{node.node_name}</a>"
      parent_link = "<a href='./#{node_parent.atlas_node_id}.html'>#{node_parent.node_name}</a>"
      child_links = "<li><a href='./#{child1.atlas_node_id}.html'>#{child1.node_name}</a></li><li><a href='./#{child2.atlas_node_id}.html'>#{child2.node_name}</a></li>"
      navigation_html = "<ul class='navigation' style='padding-left:10px'><li>#{parent_link}<ul class='navigation' style='padding-left:10px'><li>#{destination_link}<ul class='navigation' style='padding-left:10px'>#{child_links}</ul></li></ul></li></ul>"

      destinationHtml.send(:navigation, node).should == navigation_html
    end
  end

  describe "#save" do
    it "writes a html file to the given directory" do
      output_path = "output/path/"
      destinationHtml = BatchProcessor::DestinationHtml.new(double(:node, node_name:"Africa", atlas_node_id:"12345"))
      destinationHtml.stub(:puts)
      # BatchProcessor::DestinationHtml.stub(:new) { destinationHtml }
      html = double(:html)
      destinationHtml.should_receive(:html) { html }

      file = double(:file)
      File.stub(:open).with("#{output_path}/12345.html", "w").and_yield(file)
      file.should_receive(:write).with(html)

      destinationHtml.save(output_path)
    end
  end

  describe "#destination_content" do
    it "reads the destination content from destination file with atlas_node_id" do
      # destinationHtml = BatchProcessor::DestinationHtml.new("Africa", "12345")
      File.should_receive(:read).with("destinations/12345.xml") { "<destination><introductory><introduction><overview>Cool Stuff</overview></introduction></introductory></destination>" }

      destinationHtml.send(:destination_content).should == "<h1>Overview</h1><span>Cool Stuff</span></br></br></br></br>"
      # <h1>Overivew</h1><span>Cool Stuff</span></br></br></br></br>"
    end
  end

end
