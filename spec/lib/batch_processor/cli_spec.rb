require 'spec_helper'

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
      subject.should_receive(:process_destinations).with(taxonomy_path)
      subject.execute()
    end

  end

  describe "#process_destinations" do
    it "batches and processes destinations" do
      batcher = double(:batcher)
      batcher.stub(:each).and_yield("destination1")
      BatchProcessor::Batcher.stub(:new) { batcher }

      subject.should_receive(:process_batch).exactly(1).times
      subject.send(:process_destinations, taxonomy_path)
    end

    it "creates a clean output directory" do
      taxonomies = double(:taxonomies)
      taxonomies.stub(:each).and_yield(double(:taxonomy, nodes: []))
      BatchProcessor::Taxonomies.stub(:parse) { taxonomies }
      subject.should_receive(:cleanup_directory).with(BatchProcessor::CLI::OUTPUT_PATH)
      subject.send(:process_destinations, taxonomy_path)
    end

    it "copies static resource to output directory" do
      taxonomies = double(:taxonomies)
      taxonomies.stub(:each).and_yield(double(:taxonomy, nodes: []))
      BatchProcessor::Taxonomies.stub(:parse) { taxonomies }
      subject.should_receive(:output_static_resources)
      subject.send(:process_destinations, taxonomy_path)
    end
  end

  describe "#process_batch" do
    let(:batch) { (1..5) }

    it "processes each item in the batch" do
      subject.should_receive(:process_destination).exactly(5).times
      subject.send(:process_batch, batch)
    end
  end

  describe "#process_destination" do
    let(:node) { double(:node, node_name: "Africa", atlas_node_id: "33064") }
    let(:destinationHtml) { double(:destinationHtml) }

    before do
      BatchProcessor::DestinationHtml.stub(:new) { destinationHtml }
      destinationHtml.stub(:save)
    end

    it "creates a html file for the destination in the output directory" do
      destinationHtml = double(:destinationHtml)
      BatchProcessor::DestinationHtml.stub(:new) { destinationHtml }
      destinationHtml.should_receive(:save).with(BatchProcessor::CLI::OUTPUT_PATH)
      destinationHtml.stub(:save)

      subject.send(:process_destination, node)
    end

    it "uses the node name as the destination name" do
      BatchProcessor::DestinationHtml.should_receive(:new).with(node) { destinationHtml }
      subject.send(:process_destination, node)
    end

    it "generates the html from a template" do
      subject.send(:process_destination, node)
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
      subject.should_receive(:cleanup_directory)

      subject.send(:split_destinations_content, path)
    end

  end

  describe "#cleanup_directory" do
    let(:destinations_path) { "/tmp/destinations/" }

    context "no directory exists" do
      it "creates a directory" do
        subject.send(:cleanup_directory, destinations_path)

        directories = `ls /tmp/`
        directories.include?("destinations").should be_true
      end
    end

    context "directory already exists" do
      it "deletes the existing directory" do
        `rm -rf #{destinations_path}`
        Dir.stub(:exists?) { true }
        FileUtils.should_receive(:remove_dir).with(destinations_path, true)

        subject.send(:cleanup_directory, destinations_path)

        directories = `ls /tmp/`
        directories.include?("destinations").should be_true
      end
    end
  end

end
