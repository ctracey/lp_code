module BatchProcessor
  class NodeParent

    def initialize(data)
      @data = data
    end

    def nodes
      return @nodes unless @nodes.nil?

      nodes = @data[:node]
      nodes = [nodes] unless nodes.instance_of?(Array)

      @nodes = nodes
    end

  end
end
