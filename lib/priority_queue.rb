
class PriorityQueue
  def initialize k, &cmp
    @capacity = k
    @cmp = cmp
    @items = []
  end

  attr_reader :capacity, :items

  def full?
    @items.size == @capacity
  end

  def add value
    return if @capacity == 0 # Edge case sanity check

    if !full?
      @items = PriorityQueue.insert value, @items, @cmp
    elsif @cmp.call(value, @items.last) < 0
      # The list is at capacity so remove the last element and add new element
      @items = PriorityQueue.insert value, @items.slice(0..-2), @cmp
    end
  end

  def self.insert node, list, cmp
    size = list.size

    return [node] if size == 0 # Edge case of empty list

    # Split the list in half and merge the result
    # For odd numbers, skew to the right
    left = list[0, size / 2]
    right = list[(size / 2)..-1]

    cmp_result = cmp.call(node, right.first)
    if cmp_result > 0
      if right.size == 1 # Leaf case where there is only 1 element in the list
        left + right + [node]
      else
        left + insert(node, right, cmp)
      end
    elsif left.empty?
      [node] + right
    else
      insert(node, left, cmp) + right
    end
  end
end
