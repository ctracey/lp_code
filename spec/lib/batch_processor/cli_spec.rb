describe "BatchProcessor::CLI" do

  subject { BatchProcessor::CLI.new("path") }

  describe "#execute" do

    it "starts processing the destinations" do
      subject.should_receive(:split_destinations_content)
      subject.execute()
    end

  end
end
