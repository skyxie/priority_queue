
require 'priority_queue'

RSpec.describe(PriorityQueue) do
  describe "when k is 0" do
    let(:queue) { PriorityQueue.new(0) { |x| x } }

    before { 2.times { |i| queue.add i } }

    it 'should be empty' do
      expect(queue.items).to be_empty
    end
  end

  describe "when order is descending" do
    let(:capacity) { 5 }
    let(:order) { PriorityQueue::DESCENDING }
    let(:weight_function) { -> (x) { x } }

    let(:queue) { PriorityQueue.new(capacity, order, &weight_function) }

    let(:values) { [10, 14, 3, 9, 8, 4, 0, 2, 19, 1] }

    before { values.each { |i| queue.add i } }

    describe "when there are fewer than k values" do
      let(:values) { [0, 1] }

      it 'should have all values in order' do
        expect(queue.items).to eql([1, 0])
      end
    end

    describe "when there are more than k values" do
      it 'should only have k values of lowest weight' do
        expect(queue.items).to eql(values.sort.reverse.slice(0, capacity))
      end

      describe "when all values have identical weight" do
        let(:capacity) { 3 }
        let(:weight_function) { -> (x) { 1 } }

        it 'should fill to capacity and stop adding elements' do
          expect(queue.items).to eql(values.slice(0, capacity).reverse)
        end
      end
    end
  end

  describe "when order is ascending" do
    let(:order) { PriorityQueue::ASCENDING }
    let(:weight_function) { -> (x) { x } }
    let(:capacity) { 5 }

    let(:queue) { PriorityQueue.new(capacity, order, &weight_function) }

    let(:values) { [10, 14, 3, 9, 8, 4, 0, 2, 19, 1] }

    before { values.each { |i| queue.add i } }

    describe "when there are fewer than k values" do
      let(:values) { [0, 1] }

      it 'should have all values in order' do
        expect(queue.items).to eql([0, 1])
      end
    end

    describe "when there are more than k values" do
      it 'should only have k values of lowest weight' do
        expect(queue.items).to eql(values.sort.slice(0, capacity))
      end

      describe "when all values have identical weight" do
        let(:capacity) { 3 }
        let(:weight_function) { -> (x) { 1 } }

        it 'should fill to capacity and stop adding elements' do
          expect(queue.items).to eql(values.slice(0, capacity).reverse)
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
end
