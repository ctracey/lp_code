describe "BatchProcessor::Destination" do

  subject { BatchProcessor::Destination.new xmldoc }

  describe "#atlas_id" do
    let(:id) { 355064 }
    let(:atlas_id) { double(:attribute, value: id ) }
    let(:xmldoc) { double(:xmldoc, attribute: atlas_id) }

    it "returns the atlas_id attribute from the root element" do
      xmldoc.stub(:atttribute).with("atlas_id") { atlas_id }
      subject.atlas_id.should == id
    end
  end

end
