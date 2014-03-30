describe "BatchProcessor::CLI" do

  subject { BatchProcessor::CLI.new("path") }

  before do
    subject.stub(:puts)
  end

  describe "#execute" do

    it "starts processing the destinations" do
      subject.should_receive(:split_destinations_content)
      subject.execute()
    end

  end

  describe "#split_destinations_content" do

    it "splits the destinations" do
      path = "path/to/desinations.xml"

      destinations = double(:destinations)
      BatchProcessor::Destinations.stub(:new).with(path) { destinations }
      destinations.should_receive(:each)

      subject.send(:split_destinations_content, path)
    end

  end

end
