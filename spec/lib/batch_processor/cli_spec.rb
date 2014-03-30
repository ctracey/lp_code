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
    let(:path) { "path/to/desinations.xml" }
    let(:destinations) { double(:destinations) }

    before do
      BatchProcessor::Destinations.stub(:new).with(path) { destinations }
    end

    it "splits the destinations" do
      destinations.should_receive(:each)
      subject.send(:split_destinations_content, path)
    end

    it "writes each destination to a file" do
      destination = double(:destination, atlas_id: 1)
      destinations.stub(:each).and_yield(destination)
      destination.should_receive(:save)

      subject.send(:split_destinations_content, path)
    end

    it "cleans destinations directory" do
      destination = double(:destination, atlas_id: 1)
      destination.stub(:save)
      destinations.stub(:each).and_yield(destination)
      subject.should_receive(:cleanup_destinations)

      subject.send(:split_destinations_content, path)
    end

  end

  describe "#cleanup_destinations" do
    let(:destinations_path) { "/tmp/destinations/" }

    context "no directory exists" do
      it "creates a destinations directory" do
        subject.send(:cleanup_destinations, destinations_path)

        directories = `ls /tmp/`
        directories.include?("destinations").should be_true
      end
    end

    context "directory already exists" do
      it "deletes the existing directory" do
        `rm -rf #{destinations_path}`
        Dir.stub(:exists?) { true }
        FileUtils.should_receive(:remove_dir).with(destinations_path, true)

        subject.send(:cleanup_destinations, destinations_path)

        directories = `ls /tmp/`
        directories.include?("destinations").should be_true
      end
    end
  end

end
