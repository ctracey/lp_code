require 'spec_helper'

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

  let(:data) { {:taxonomies=>{:taxonomy=>{:taxonomy_name=>"World"}}} }

  before do
    File.stub(:read) { xml }
  end

  describe ".parse" do
    it "returns a Taxonomies instance" do
      BatchProcessor::Taxonomies.parse("/path/to/xml").instance_of?(BatchProcessor::Taxonomies).should be_true
    end

    it "creates a Taxonomies with hash representing parsed xml" do
      BatchProcessor::Taxonomies.should_receive(:new).with(data)
      BatchProcessor::Taxonomies.parse("/path/to/xml")
    end
  end

  describe "#each" do
    let(:taxonomies) { BatchProcessor::Taxonomies.parse("/path/to/xml") }

    context "a single taxonomy" do
      it "yields a NodeParent" do
        count = 0
        taxonomies.each do |taxonomy|
          count += 1
          taxonomy.instance_of?(BatchProcessor::NodeParent).should be_true
        end
        count.should == 1
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

      it "yields multiple NodeParents" do
        count = 0
        taxonomies.each { count += 1 }
        count.should == 2
      end
    end
  end

end
