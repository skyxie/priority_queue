
class PriorityQueue
  Node = Struct.new(:weight, :value)

  # Enumeration for order of queue
  ASCENDING = 0  # Lower weight = higher priority
  DESCENDING = 1 # Higher weight = higher priority

  def initialize k, order=ASCENDING, &weight_function
    @capacity = k
    @order = order
    @weight_function = weight_function
    @nodes = []
  end

  attr_reader :capacity

  def items
    # List of nodes is kept in reverse order so that first node is always the limit weight
    # Reverse order on output
    @nodes.map(&:value).reverse
  end

  def full?
    @nodes.size == @capacity
  end

  def asc?
    @order == ASCENDING
  end

  def desc?
    @order == DESCENDING
  end

  def limit_weight
    @nodes.empty? ? 0 : @nodes.first.weight
  end

  def add value
    return if @capacity == 0 # Edge case sanity check

    weight = @weight_function.call(value)
    new_node = Node.new(weight, value)

    if !full?
      @nodes = PriorityQueue.insert new_node, @nodes, @order
    elsif (asc? && weight < limit_weight) || (desc? && weight > limit_weight)
      # The list is at capacity so drop the first element and add new element
      @nodes.shift
      @nodes = PriorityQueue.insert new_node, @nodes, @order
    end
  end

  def self.insert node, list, order
    size = list.size

    return [node] if size == 0 # Edge case of empty list

    # Split the list in half and merge the result
    # For odd numbers, skew to the right
    left = list[0, size / 2]
    right = list[(size / 2)..-1]

    if (order == ASCENDING && right.first.weight >= node.weight) ||
        (order == DESCENDING && right.first.weight <= node.weight)
      # Leaf case where there is only 1 element in the list
      if right.size == 1
        left + right + [node]
      else
        left + insert(node, right, order)
      end
    elsif left.empty?
      [node] + right
    else
      insert(node, left, order) + right
    end
  end
end
