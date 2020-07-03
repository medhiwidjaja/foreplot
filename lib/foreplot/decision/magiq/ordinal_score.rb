module Foreplot
  module Decision
    module Magiq
      module OrdinalScore

        # Rank Order Centroid
        # k = total number of criteria
        # i = rank of the i-th criterion
        def rank_order_centroid(k, i)
          (i..k).map { |j| 1.0/j }.sum / k
        end

        def rank_order_centroid_table(k)
          (1..k).map { |j| rank_order_centroid(k, j) }
        end

        # Rank Sum
        # k = total number of criteria
        # i = rank of the i-th criterion
        def rank_sum(k, i)
          (k - i + 1.0) / (1..k).map { |j| k - j + 1.0 }.sum
        end

        def rank_sum_table(k)
          (1..k).map { |j| rank_sum(k, j) }
        end

        # Rank Reciprocal
        # k = total number of criteria
        # i = rank of the i-th criterion
        def rank_reciprocal(k, i)
          (1.0/i) / (1..k).map { |j| 1.0/j }.sum
        end

        def rank_reciprocal_table(k)
          (1..k).map { |j| rank_reciprocal(k, j) }
        end

        # Rank Exponential
        # k = total number of criteria
        # i = rank of the i-th criterion
        # d = dispersion (0.0 .. 1.0)
        def rank_exponential(k, i, d=0.2) 
          (k-i+1)**d / (1..k).map { |j| (k - j + 1.0)**d }.sum
        end

        def rank_exponential_table(k, d=0.2)
          (1..k).map { |j| rank_exponential(k, j, d) }
        end

      end
    end
  end
end

