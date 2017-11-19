require 'priority_queue'

class WeightedQueue < PriorityQueue
  Node = Struct.new(:weight, :value)

  # Enumeration for order of queue
  ASCENDING = 0  # Lower weight = higher priority
  DESCENDING = 1 # Higher weight = higher priority

  def initialize capacity, order=ASCENDING, &weight_function
    @order = order
    @weight_function = weight_function
    super(capacity) do |a, b|
      if @order == ASCENDING
        a.weight <=> b.weight
      else
        b.weight <=> a.weight
      end
    end
  end

  def items
    super.map(&:value) # Extract values from nodes
  end

  def min_weight
    if @order == ASCENDING
      @items.first.weight
    else
      @items.last.weight
    end
  end

  def max_weight
    if @order == ASCENDING
      @items.last.weight
    else
      @items.first.weight
    end
  end

  def asc?
    @order == ASCENDING
  end

  def desc?
    @order == DESCENDING
  end

  def add value
    return if @capacity == 0 # Edge case sanity check
    super(Node.new(@weight_function.call(value), value))
  end
end
