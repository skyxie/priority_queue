
require 'weighted_queue'

RSpec.describe(WeightedQueue) do
  let(:capacity) { 5 }
  let(:cmp) { -> (a, b) { a <=> b } }
  let(:order) { WeightedQueue::ASCENDING }
  let(:weight_function) { -> (x) { x } }

  let(:queue) { WeightedQueue.new(capacity, order, &weight_function) }

  before { values.each { |i| queue.add i } }

  describe "when capacity is 0" do
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

    it 'should indicate max weight' do
      expect(queue.max_weight).to eql(1)
    end

    it 'should indicate min weight' do
      expect(queue.min_weight).to eql(0)
    end

    describe "when order is descending" do
      let(:order) { WeightedQueue::DESCENDING }

      it 'should indicate max weight' do
        expect(queue.max_weight).to eql(1)
      end

      it 'should indicate min weight' do
        expect(queue.min_weight).to eql(0)
      end

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

    it 'should indicate max weight' do
      expect(queue.max_weight).to eql(4)
    end

    it 'should indicate min weight' do
      expect(queue.min_weight).to eql(0)
    end

    describe "when order is descending" do
      let(:order) { WeightedQueue::DESCENDING }

      it 'should indicate max weight' do
        expect(queue.max_weight).to eql(19)
      end

      it 'should indicate min weight' do
        expect(queue.min_weight).to eql(8)
      end

      it 'should have all values in order' do
        expect(queue.items).to eql(values.sort.reverse.slice(0, capacity))
      end
    end
  end

  describe "find closest k distances" do
    let(:weight_function) do
      sol = [5.0e-06,0.0,0.0]
      -> (x) {
        sol.zip(x).reduce(0) do |dist, (a, b)|
          dist + (a - b) ** 2
        end
      }
    end

    let(:capacity) { 3 }

    let(:values) do
      [
        [219.740502,0.003449,4.177065],
        [45.210918,0.003365,-16.008996],
        [344.552785,0.030213,277.614965],
        [82.835513,0.012476,-105.61954],
        [195.714261,0.034068,-167.695291],
        [54.905296,0.017912,3.787796],
        [54.367897,0.020886,19.827115],
        [180.654532,0.086213,87.668389]
      ]
    end

    it "should find the k closest points" do
      expect(queue.items).to eql([values[1], values[5], values[6]])
    end
  end
end
