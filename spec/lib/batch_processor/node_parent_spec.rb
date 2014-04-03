require 'spec_helper'

describe "BatchProcessor::NodeParent" do

  #I would prefer to use newer hash syntax but Nori gem is parsing the xml in this format so I'm testing with this syntax
  let(:data) { {:taxonomy_name=>"World", :node=>{:node_name=>"Africa", :node=>[{:node_name=>"South Africa", :node=>[{:node_name=>"Cape Town", :node=>{:node_name=>"Table Mountain National Park", :@atlas_node_id=>"355613", :@ethyl_content_object_id=>"", :@geo_id=>"355613"}, :@atlas_node_id=>"355612", :@ethyl_content_object_id=>"35474", :@geo_id=>"355612"}, {:node_name=>"Free State", :node=>{:node_name=>"Bloemfontein", :@atlas_node_id=>"355615", :@ethyl_content_object_id=>"1000550692", :@geo_id=>"355615"}, :@atlas_node_id=>"355614", :@ethyl_content_object_id=>"", :@geo_id=>"355614"}, {:node_name=>"Gauteng", :node=>[{:node_name=>"Johannesburg", :@atlas_node_id=>"355617", :@ethyl_content_object_id=>"37710", :@geo_id=>"355617"}, {:node_name=>"Pretoria", :@atlas_node_id=>"355618", :@ethyl_content_object_id=>"1000548256", :@geo_id=>"355618"}], :@atlas_node_id=>"355616", :@ethyl_content_object_id=>"", :@geo_id=>"355616"}, {:node_name=>"KwaZulu-Natal", :node=>[{:node_name=>"Durban", :@atlas_node_id=>"355620", :@ethyl_content_object_id=>"43725", :@geo_id=>"355620"}, {:node_name=>"Pietermaritzburg", :@atlas_node_id=>"355621", :@ethyl_content_object_id=>"1000576780", :@geo_id=>"355621"}], :@atlas_node_id=>"355619", :@ethyl_content_object_id=>"", :@geo_id=>"355619"}, {:node_name=>"Mpumalanga", :node=>{:node_name=>"Kruger National Park", :@atlas_node_id=>"355623", :@ethyl_content_object_id=>"67561", :@geo_id=>"355623"}, :@atlas_node_id=>"355622", :@ethyl_content_object_id=>"", :@geo_id=>"355622"}, {:node_name=>"The Drakensberg", :node=>{:node_name=>"Royal Natal National Park", :@atlas_node_id=>"355625", :@ethyl_content_object_id=>"", :@geo_id=>"355625"}, :@atlas_node_id=>"355624", :@ethyl_content_object_id=>"", :@geo_id=>"355624"}, {:node_name=>"The Garden Route", :node=>[{:node_name=>"Oudtshoorn", :@atlas_node_id=>"355627", :@ethyl_content_object_id=>"", :@geo_id=>"355627"}, {:node_name=>"Tsitsikamma Coastal National Park", :@atlas_node_id=>"355628", :@ethyl_content_object_id=>"", :@geo_id=>"355628"}], :@atlas_node_id=>"355626", :@ethyl_content_object_id=>"", :@geo_id=>"355626"}], :@atlas_node_id=>"355611", :@ethyl_content_object_id=>"3210", :@geo_id=>"355611"}, {:node_name=>"Sudan", :node=>[{:node_name=>"Eastern Sudan", :node=>{:node_name=>"Port Sudan", :@atlas_node_id=>"355631", :@ethyl_content_object_id=>"", :@geo_id=>"355631"}, :@atlas_node_id=>"355630", :@ethyl_content_object_id=>"", :@geo_id=>"355630"}, {:node_name=>"Khartoum", :@atlas_node_id=>"355632", :@ethyl_content_object_id=>"", :@geo_id=>"355632"}], :@atlas_node_id=>"355629", :@ethyl_content_object_id=>"3263", :@geo_id=>"355629"}, {:node_name=>"Swaziland", :@atlas_node_id=>"355633", :@ethyl_content_object_id=>"3272", :@geo_id=>"355633"}], :@atlas_node_id=>"355064", :@ethyl_content_object_id=>"82534", :@geo_id=>"355064"}} }

  subject { BatchProcessor::NodeParent.new(data) }

  describe "#parent" do
    it "returns nil when created without a parent" do
      subject.parent.should be_nil
    end

    it "returns the parent when created with one" do
      parent = double(:parent)
      nodeParent = BatchProcessor::NodeParent.new(data, parent)
      nodeParent.parent.should == parent
    end

  end

  describe "#nodes" do
    let(:node_data) { double(:node_Data) }
    let(:data) { {:taxonomy_name=>"World", :node=>node_data} }

    it "returns nodes" do
      node = double(:nodes)
      BatchProcessor::Node.stub(:new).with(node_data, nil) { node }
      subject.nodes.should == [node]
    end
  end

  describe "#parse_nodes" do
    it "returns an empty array if data has no nodes" do
      data = {:taxonomy_name=>"World"}
      subject.parse_nodes(data).should == []
    end

    it "returns an array with single node if data node is a hash of attributes" do
      node = {}
      data = {:taxonomy_name=>"World", :node=> node}
      nodes = subject.parse_nodes(data)
      nodes.size.should == 1
      nodes.first.instance_of?(BatchProcessor::Node).should be_true
    end

    it "returns an array of nodes if data node is a collection of nodes" do
      node = [{}, {}]
      data = {:taxonomy_name=>"World", :node=> node}
      nodes = subject.parse_nodes(data)
      nodes.size.should == 2
    end

    it "creates a node with nil parent" do
      node = {}
      data = {:taxonomy_name=>"World", :node=> node}
      nodes = subject.parse_nodes(data)
      nodes.first.parent.should be_nil
    end

    it "creates a node with this as the parent if this is a Node" do
      nodeParent = BatchProcessor::Node.new(data) #Node extends NodeParent
      node = {}
      data = {:taxonomy_name=>"World", :node=> node}
      nodes = nodeParent.parse_nodes(data)
      nodes.first.parent.should == nodeParent
    end
  end

end
