require 'spec_helper'

describe "BatchProcessor::Destinations" do

  subject { BatchProcessor::Destinations.new(path) }

  describe "#each" do

    context "valid xml" do
      let(:path) { "spec/fixtures/destinations.xml" }

      it "yields a destination per destination in the destinations xml" do
        count = 0
        subject.each do |destination|
          destination.instance_of?(BatchProcessor::Destination).should be_true
          count += 1
        end
        count.should == 24
      end
    end

    context "empty xml" do
      let(:path) { "spec/fixtures/empty.xml" }

      it "yields no destinations" do
        count = 0
        subject.each { count += 1 }
        count.should == 0
      end
    end

    context "invalid xml" do
      let(:path) { "spec/fixtures/invalid.xml" }

      it "raises an error" do
        error_msg = "Error parsing #{path}: Premature end of data in tag destinations line 2"
        expect { subject.each {} }.to raise_error(error_msg)
      end
    end

  end

end
