require 'spec_helper'

describe "BatchProcessor::Destination" do

  subject { BatchProcessor::Destination.new xmldoc }

  let(:id) { 355064 }
  let(:atlas_id) { double(:attribute, value: id ) }
  let(:destination_content) { "<destination>cool stuff</destination>" }
  let(:xmldoc) { double(:xmldoc, attribute: atlas_id, to_s: destination_content) }

  describe "#atlas_id" do
    it "returns the atlas_id attribute from the root element" do
      xmldoc.stub(:atttribute).with("atlas_id") { atlas_id }
      subject.atlas_id.should == id
    end
  end

  describe "#save" do

    it "returns the filename based on atlas_id" do
      subject.save("/tmp").should == "#{id}.xml"
    end

    it "writes to a file at the specified path" do
      subject.save "/tmp"
      files = `ls /tmp/*.xml`
      files.include?("#{id}.xml").should be_true
    end

    it "writes the destination content to file" do
      subject.save "/tmp"
      contents = File.read("/tmp/#{id}.xml")
      contents.should == destination_content
    end
  end

end
