require 'spec_helper'

describe "BatchProcessor::Batcher" do

  let(:collection) { (1..24) }
  let(:max_batches) { 5 }

  subject { BatchProcessor::Batcher.new(collection, max_batches) }

  describe "each" do
    it "splits the collection into batches" do
      count = 0
      batches = subject.each { count += 1 }
      count.should <= 5
    end
  end

end
