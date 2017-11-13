
require 'priority_queue'

RSpec.describe(PriorityQueue) do
  describe "when k is 0" do
    let(:queue) { PriorityQueue.new(0) { |x| x } }

    before { 2.times { |i| queue.add i } }

    it 'should be empty' do
      expect(queue.items).to be_empty
    end
  end

  describe "when there are fewer than k values" do
    let(:queue) { PriorityQueue.new(3) { |x| x } }

    before { 2.times { |i| queue.add i } }

    it 'should have all values in order' do
      expect(queue.items).to eql([1, 0])
    end
  end

  describe "when there are more than k values" do
    let(:queue) { PriorityQueue.new(5) { |x| x } }

    before do
      [10, 14, 3, 9, 8, 4, 0, 2, 19, 1].each { |i| queue.add i }
    end

    it 'should only have k values of lowest weight' do
      expect(queue.items).to eql([4, 3, 2, 1, 0])
    end

    describe "when all values have identical weight" do
      let(:queue) { PriorityQueue.new(3) { |x| 1 } }

      it 'should fill to capacity and stop adding elements' do
        expect(queue.items).to eql([10, 14, 3])
      end
    end
  end

  describe "find closest k distances" do
    let(:sol) { [5.0e-06,0.0,0.0] }

    let(:queue) do
      PriorityQueue.new(3) do |x|
        sol.zip(x).reduce(0) do |dist, (a, b)|
          dist + (a - b) ** 2
        end
      end
    end

    before do
      [
        [219.740502,0.003449,4.177065],
        [45.210918,0.003365,-16.008996],
        [344.552785,0.030213,277.614965],
        [82.835513,0.012476,-105.61954],
        [195.714261,0.034068,-167.695291],
        [54.905296,0.017912,3.787796],
        [54.367897,0.020886,19.827115],
        [180.654532,0.086213,87.668389]
      ].each do |x|
        queue.add x
      end
    end

    it "should find the k closest points" do
      expect(queue.items).to eql([
        [54.367897,0.020886,19.827115],
        [54.905296,0.017912,3.787796],
        [45.210918,0.003365,-16.008996]
      ])
    end
  end
end
