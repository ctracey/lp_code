describe "BatchProcessor::NodeParent" do

  let(:data) { {:taxonomy_name=>"World", :node=>{:node_name=>"Africa", :node=>[{:node_name=>"South Africa", :node=>[{:node_name=>"Cape Town", :node=>{:node_name=>"Table Mountain National Park", :@atlas_node_id=>"355613", :@ethyl_content_object_id=>"", :@geo_id=>"355613"}, :@atlas_node_id=>"355612", :@ethyl_content_object_id=>"35474", :@geo_id=>"355612"}, {:node_name=>"Free State", :node=>{:node_name=>"Bloemfontein", :@atlas_node_id=>"355615", :@ethyl_content_object_id=>"1000550692", :@geo_id=>"355615"}, :@atlas_node_id=>"355614", :@ethyl_content_object_id=>"", :@geo_id=>"355614"}, {:node_name=>"Gauteng", :node=>[{:node_name=>"Johannesburg", :@atlas_node_id=>"355617", :@ethyl_content_object_id=>"37710", :@geo_id=>"355617"}, {:node_name=>"Pretoria", :@atlas_node_id=>"355618", :@ethyl_content_object_id=>"1000548256", :@geo_id=>"355618"}], :@atlas_node_id=>"355616", :@ethyl_content_object_id=>"", :@geo_id=>"355616"}, {:node_name=>"KwaZulu-Natal", :node=>[{:node_name=>"Durban", :@atlas_node_id=>"355620", :@ethyl_content_object_id=>"43725", :@geo_id=>"355620"}, {:node_name=>"Pietermaritzburg", :@atlas_node_id=>"355621", :@ethyl_content_object_id=>"1000576780", :@geo_id=>"355621"}], :@atlas_node_id=>"355619", :@ethyl_content_object_id=>"", :@geo_id=>"355619"}, {:node_name=>"Mpumalanga", :node=>{:node_name=>"Kruger National Park", :@atlas_node_id=>"355623", :@ethyl_content_object_id=>"67561", :@geo_id=>"355623"}, :@atlas_node_id=>"355622", :@ethyl_content_object_id=>"", :@geo_id=>"355622"}, {:node_name=>"The Drakensberg", :node=>{:node_name=>"Royal Natal National Park", :@atlas_node_id=>"355625", :@ethyl_content_object_id=>"", :@geo_id=>"355625"}, :@atlas_node_id=>"355624", :@ethyl_content_object_id=>"", :@geo_id=>"355624"}, {:node_name=>"The Garden Route", :node=>[{:node_name=>"Oudtshoorn", :@atlas_node_id=>"355627", :@ethyl_content_object_id=>"", :@geo_id=>"355627"}, {:node_name=>"Tsitsikamma Coastal National Park", :@atlas_node_id=>"355628", :@ethyl_content_object_id=>"", :@geo_id=>"355628"}], :@atlas_node_id=>"355626", :@ethyl_content_object_id=>"", :@geo_id=>"355626"}], :@atlas_node_id=>"355611", :@ethyl_content_object_id=>"3210", :@geo_id=>"355611"}, {:node_name=>"Sudan", :node=>[{:node_name=>"Eastern Sudan", :node=>{:node_name=>"Port Sudan", :@atlas_node_id=>"355631", :@ethyl_content_object_id=>"", :@geo_id=>"355631"}, :@atlas_node_id=>"355630", :@ethyl_content_object_id=>"", :@geo_id=>"355630"}, {:node_name=>"Khartoum", :@atlas_node_id=>"355632", :@ethyl_content_object_id=>"", :@geo_id=>"355632"}], :@atlas_node_id=>"355629", :@ethyl_content_object_id=>"3263", :@geo_id=>"355629"}, {:node_name=>"Swaziland", :@atlas_node_id=>"355633", :@ethyl_content_object_id=>"3272", :@geo_id=>"355633"}], :@atlas_node_id=>"355064", :@ethyl_content_object_id=>"82534", :@geo_id=>"355064"}} }

  subject { BatchProcessor::NodeParent.new(data) }

  describe "#nodes" do
    context "multiple nodes exist" do
      let(:data) { {:taxonomy_name=>"World", :node=>[{:node_name=>"Africa"}, {:node_name=>"Asia"}]} }

      it "returns an array of nodes" do
        nodes = subject.nodes
        nodes.instance_of?(Array)
        nodes.size.should == 2
      end
    end

    context "single node exists" do
      it "returns an array of nodes " do
        nodes = subject.nodes
        nodes.instance_of?(Array)
        nodes.size.should == 1
      end
    end
  end

end
