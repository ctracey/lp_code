require 'spec_helper'

describe "BatchProcessor::Batcher" do

  let(:max_batches) { 5 }

  subject { BatchProcessor::Batcher.new(collection, max_batches) }

  describe "each" do
    context "batching" do
      let(:collection) { (1..24) }

      it "splits the collection into batches" do
        count = 0
        subject.each { count += 1 }
        count.should <= 5
      end
    end

    context "batch_handling" do
      let(:collection) { (1..3) }

      it "spawns a new process for each batch" do
        subject.each do
          sleep(2)
        end
        console = `ps -ef | grep batch_processor`
        processes = console.split("\n")
        (2..4).each do |i|
          match = processes[i] =~ /batch_processor/
          match.should > 0
        end
      end
    end
  end

end
