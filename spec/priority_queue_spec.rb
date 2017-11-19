require 'priority_queue'

RSpec.describe PriorityQueue do
  let(:capacity) { 5 }
  let(:cmp) { -> (a, b) { a <=> b } }
  let(:queue) { PriorityQueue.new(capacity, &cmp) }

  before { values.each { |i| queue.add i } }

  describe 'when capacity is zero' do
    let(:capacity) { 0 }

    let(:values) { [1] }

    it 'should not add any elements' do
      expect(queue.items).to be_empty
    end
  end

  describe "when values are fewer than capacity" do
    let(:values) { [0, 1] }

    it 'should have all values in order' do
      expect(queue.items).to eql([0, 1])
    end

    describe "when order is descending" do
      let(:cmp) { -> (a, b) { b <=> a } }

      it 'should have all values in order' do
        expect(queue.items).to eql([1, 0])
      end
    end
  end

  describe "when values are more than capacity" do
    let(:values) { [10, 14, 3, 9, 8, 4, 0, 2, 19, 1] }

    it 'should only have up to capacity items' do
      expect(queue.items).to eql(values.sort.slice(0, capacity))
    end

    describe "when order is descending" do
      let(:cmp) { -> (a, b) { b <=> a } }

      it 'should have all values in order' do
        expect(queue.items).to eql(values.sort.reverse.slice(0, capacity))
      end
    end
  end
end
