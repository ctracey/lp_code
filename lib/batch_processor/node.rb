module BatchProcessor
  class Node < NodeParent

    def initialize(data)
      @data = data
    end

    def node_name
      @node_name = @data[:node_name] if @node_name.nil?
      @node_name
    end

    def atlas_node_id
      @atlas_node_id = @data[:@atlas_node_id] if @atlas_node_id.nil?
      @atlas_node_id
    end

  end
end
