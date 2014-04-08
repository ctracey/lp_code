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

      subject.stub(:taxonomy_path) { taxonomy_path }
      subject.stub(:process_destinations)
    end

    it "processes the destinations" do
      subject.should_receive(:process_destinations)
      subject.execute()
    end

  end

  describe "#process_destinations" do
    let(:destinations) { double(:destinations) }
    let(:destination) { double(:destination, atlas_id: 1) }
    let(:taxonomy) { double(:taxonomy, nodes: []) }

    before do
      destination_taxonomy = {1=> taxonomy}
      subject.stub(:parse_taxonomy) { destination_taxonomy }

      BatchProcessor::Destinations.stub(:new) { destinations }
      destinations.stub(:each).and_yield(destination)

      subject.stub(:process_destination)
    end

    it "creates a clean output directory" do
      subject.should_receive(:cleanup_directory).with(BatchProcessor::CLI::OUTPUT_PATH)
      subject.send(:process_destinations)
    end

    it "copies static resource to output directory" do
      subject.should_receive(:output_static_resources)
      subject.send(:process_destinations)
    end

    it "parses the taxonomies file" do
      subject.should_receive(:parse_taxonomy)
      subject.send(:process_destinations)
    end

    it "processes each destintion" do
      destinations.should_receive(:each).and_yield(destination)
      subject.should_receive(:process_destination).with(destination, taxonomy)

      subject.send(:process_destinations)
    end
  end

  describe "#parse_taxonomy" do
    it "returns a hash with an object representing each destination" do
      subject.stub(:taxonomy_path) { taxonomy_path }

      destination1 = double(:destination, atlas_node_id: 1)
      destination2 = double(:destination, atlas_node_id: 2)
      node1 = double(:node, nodes: [double(:node, destinations:[destination1, destination2])])
      taxonomies = double(:taxonomies)
      taxonomies.stub(:each).and_yield(node1)
      BatchProcessor::Taxonomies.should_receive(:parse).with(taxonomy_path) { taxonomies }

      subject.send(:parse_taxonomy).should == {1=> destination1, 2=> destination2}
    end
  end

  describe "#process_destination" do
    let(:node) { double(:node, node_name: "Africa", atlas_node_id: "33064") }
    let(:destination) { double(:destination) }
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

      subject.send(:process_destination, destination, node)
    end

    it "uses the node and the destination to generate the html" do
      BatchProcessor::DestinationHtml.should_receive(:new).with(destination, node) { destinationHtml }
      subject.send(:process_destination, destination, node)
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
