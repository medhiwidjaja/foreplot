module Foreplot
  module Magiq
    class OrdinalScore

      # Rank Order Centroid
      # k = total number of criteria
      # i = rank of the i-th criterion
      def self.rank_order_centroid(k, i)
        (i..k).map { |j| 1.0/j }.sum / k
      end

      def self.rank_order_centroid_table(k)
        (1..k).map { |j| rank_order_centroid(k, j) }
      end

      # Rank Sum
      # k = total number of criteria
      # i = rank of the i-th criterion
      def self.rank_sum(k, i)
        (k - i + 1.0) / (1..k).map { |j| k - j + 1.0 }.sum
      end

      def self.rank_sum_table(k)
        (1..k).map { |j| rank_sum(k, j) }
      end

      # Rank Reciprocal
      # k = total number of criteria
      # i = rank of the i-th criterion
      def self.rank_reciprocal(k, i)
        (1.0/i) / (1..k).map { |j| 1.0/j }.sum
      end

      def self.rank_reciprocal_table(k)
        (1..k).map { |j| rank_reciprocal(k, j) }
      end

      # Rank Exponential
      # k = total number of criteria
      # i = rank of the i-th criterion
      # d = dispersion (0.0 .. 1.0)
      def self.rank_exponential(k, i, d=0.2) 
        (k-i+1)**d / (1..k).map { |j| (k - j + 1.0)**d }.sum
      end

      def self.rank_exponential_table(k, d=0.2)
        (1..k).map { |j| rank_exponential(k, j, d) }
      end

      def self.score(ranks, rank_method=:rank_order_centroid)
        rank_table = self.send "#{rank_method}_table", ranks.size
        offset = 0
        prev_rank = 0
        ranks.sort.map.with_index do |rank, i|
          n = ranks.count rank
          offset = rank != prev_rank ? 0 : offset + 1
          score = rank_table.slice(i - offset, n).sum / n
          prev_rank = rank
          score
        end
      end

      def self.validate_scores(ranks)
        empty_slots = (1..ranks.max).to_a - ranks.uniq
        raise EmptyInteriorRankError.new(empty_slots) if empty_slots.size > 0
      end
    end
    
  end

  class EmptyInteriorRankError < StandardError
    attr_reader :message
    def initialize(empty_slots)
      @message = "Interior ranks are empty: #{empty_slots.join(', ')}"
      super @message
    end
  end
end

