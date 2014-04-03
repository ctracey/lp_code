module BatchProcessor
  class Batcher

    def initialize(collection, max_batches)
      @collection = collection
      @max_batches = max_batches
    end

    def each
      @batches = batch if @batches.nil?
      @batches.each do |batch|
        pid = fork do
          $PROGRAM_NAME = "batch_processor"
          yield batch
        end
        Process.detach(pid)
      end
    end

    private

    def batch
      num_items = @collection.size
      batch_limit = num_items / @max_batches
      batch_limit += 1 if num_items % @max_batches > 0

      batches = []
      batch = []
      batch_size = 0
      @collection.each_with_index do |n, i|
        if batch_size == batch_limit
          batches << batch
          batch = []
          batch_size = 0
        end
        batch << n
        batch_size += 1
      end
      batches << batch

      batches
    end

  end
end
