module BatchProcessor
  class Node < NodeParent

    def node_name
      @node_name = @data[:node_name] if @node_name.nil?
      @node_name
    end

    def atlas_node_id
      @atlas_node_id = @data[:@atlas_node_id] if @atlas_node_id.nil?
      @atlas_node_id
    end

    def destinations
      yield self
      nodes.each do |node|
        node.destinations do |destination|
          yield destination
        end
      end
    end

  end
end
