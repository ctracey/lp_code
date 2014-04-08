module BatchProcessor
  class NodeParent

    def initialize(data, parent=nil)
      return nil if data.nil?
      @parent = parent
      @data = data
      @nodes = parse_nodes(data)
    end

    def parent
      @parent
    end

    def nodes
      @nodes
    end

    private

    def parse_nodes(data)
      nodes = data[:node]
      nodes = [] if nodes.nil?
      nodes = [nodes] unless nodes.instance_of?(Array)

      parent_node = self if instance_of? Node
      nodes.map { |node| Node.new(node, parent_node) }
    end

  end
end
