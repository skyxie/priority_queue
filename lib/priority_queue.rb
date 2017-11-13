
class PriorityQueue
  Node = Struct.new(:weight, :value)

  def initialize k, &weight_function
    @capacity = k
    @weight_function = weight_function
    @nodes = []
  end

  attr_reader :capacity

  def items
    @nodes.map(&:value)
  end

  def full?
    @nodes.size == @capacity
  end

  def max_weight
    @nodes.empty? ? 0 : @nodes.first.weight
  end

  def add value
    return if @capacity == 0 # Edge case sanity check

    weight = @weight_function.call(value)
    new_node = Node.new(weight, value)

    if !full?
      @nodes = PriorityQueue.insert new_node, @nodes
    elsif weight < max_weight
      # The list is at capacity so drop the first and largest element
      @nodes.shift
      @nodes = PriorityQueue.insert new_node, @nodes
    end
  end

  def self.insert node, list
    size = list.size

    return [node] if size == 0

    # Split the list in half and merge the result
    # For odd numbers, skew to the right
    left = list[0, size / 2]
    right = list[(size / 2)..-1]

    if right.first.weight >= node.weight
      # Leaf case where there is only 1 element in the list
      if right.size == 1
        left + right + [node]
      else
        left + insert(node, right)
      end
    elsif left.empty?
      [node] + right
    else
      insert(node, left) + right
    end
  end
end
