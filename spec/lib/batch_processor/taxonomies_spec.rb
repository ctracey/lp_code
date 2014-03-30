describe "BatchProcessor::Taxonomies" do

  let(:xml) do
    %{
      <?xml version="1.0" encoding="utf-8"?>
      <taxonomies>
        <taxonomy>
          <taxonomy_name>World</taxonomy_name>
        </taxonomy>
      </taxonomies>
    }
  end

  describe ".parse" do

    it "returns a Taxonomies instance" do
      BatchProcessor::Taxonomies.parse(xml).instance_of?(BatchProcessor::Taxonomies).should be_true
    end

  end

  context "a single taxonomy" do
    describe "#taxonomies" do
      it "returns an array of taxonomies" do
        taxonomies = BatchProcessor::Taxonomies.parse(xml)
        count = 0
        taxonomies.each { count += 1 }
        count.should == 1
      end
    end
  end

  context "a multiple taxonomies" do
    let(:xml) do
      %{
        <?xml version="1.0" encoding="utf-8"?>
        <taxonomies>
          <taxonomy>
            <taxonomy_name>World</taxonomy_name>
            <node id="1">
              <node id="2">
              </node>
              <node id="3">
              </node>
            </node>
          </taxonomy>
          <taxonomy>
            <taxonomy_name>Space</taxonomy_name>
          </taxonomy>
        </taxonomies>
      }
    end

    describe "#taxonomies" do
      it "returns an array of taxonomies" do
        taxonomies = BatchProcessor::Taxonomies.parse(xml)
        count = 0
        taxonomies.each { count += 1 } 
        count.should == 2
      end
    end
  end

end
