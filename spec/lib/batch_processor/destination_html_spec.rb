describe "BatchProcessor::DestinationHTML" do

  let(:destinationHtml) { BatchProcessor::DestinationHtml.new(double(:node, node_name:"Africa", atlas_node_id: "12345")) }

  describe "#html" do
    let(:template) { double(:template) }
    let(:navigation) { "NAV" }

    before do
      Erubis::Eruby.stub(:new) { template }
      destinationHtml.stub(:destination_content) { "COOL STUFF" }
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

    it "generates html with the destination navigation"

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
