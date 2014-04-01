describe "BatchProcessor::CLI" do

  subject { BatchProcessor::CLI.new("path") }

  let(:destinations_path) { "spec.fixtures/destinations.xml" }
  let(:taxonomy_path) { "spec/fixtures/taxonomy.xml" }

  before do
    subject.stub(:puts)
  end

  describe "#execute" do
    before do
      subject.stub(:destinations_path){ destinations_path }
      subject.stub(:split_destinations_content)

      subject.stub(:taxonomy_path) { taxonomy_path }
      subject.stub(:process_destinations)
    end

    it "splits the desination content" do
      subject.should_receive(:split_destinations_content).with(destinations_path)
      subject.execute()
    end

    it "parses the taxonomies" do
      destination = double(:destination)
      subject.should_receive(:process_destinations).with(taxonomy_path).and_yield(destination)
      subject.should_receive(:process_destination)
      subject.execute()
    end

  end

  describe "#process_destinations" do
    it "yields each destination" do
      count = 0
      subject.send(:process_destinations, taxonomy_path) { count += 1 }
      count.should == 24
    end
  end

  describe "#process_destination" do
    it "processes the destination"
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
