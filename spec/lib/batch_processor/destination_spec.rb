require 'spec_helper'

describe "BatchProcessor::Destination" do

  subject { BatchProcessor::Destination.new xmldoc }

  let(:id) { 355064 }
  let(:atlas_id) { double(:attribute, value: id ) }
  let(:destination_content) { "<destination>cool stuff</destination>" }
  let(:xmldoc) { double(:xmldoc, attribute: atlas_id, to_s: destination_content) }

  describe "xmldoc" do
    it "returns the xml_doc" do
      subject.xmldoc.should == xmldoc
    end
  end

  describe "#atlas_id" do
    it "returns the atlas_id attribute from the root element" do
      xmldoc.stub(:atttribute).with("atlas_id") { atlas_id }
      subject.atlas_id.should == id
    end
  end

end
