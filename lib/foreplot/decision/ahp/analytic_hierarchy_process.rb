module Foreplot
  module Decision 

    module Ahp

      class AnalyticHierarchyProcess 

        def initialize(matrix, no_of_alternatives)
          @node = Foreplot::Decision::Ahp::AhpMatrix.new matrix, no_of_alternatives
          @n = no_of_alternatives
        end

        def priority_vector
          @lambda_max, idx = lambda_max
          v = @node.eigenvectors[idx].collect { |i| i.abs }
          v.map { |i| i/v.reduce(:+) }
        end
    
        def pv
          @pv ||= priority_vector
        end
    
        # The largest lambda value corresponding to the eigenvectors
        # Returns the largest lambda and the row index needed to get the corresponding eigenvector
        def lambda_max
          dmax = @node.eigenvalues.reject {|v| !v.real? }.max
          [dmax, @node.eigenvalues.index(dmax)]
        end
    
        def lm
          @lm ||= lambda_max.first
        end
    
        def inconsistency_index
          @lambda_max ||= lm
          (@lambda_max - @n) / (@n - 1)
        end
    
        def ci
          inconsistency_index
        end
    
        RANDOM_INDEX = [0.0, 0.0, 0.58, 0.9, 1.12, 1.24, 1.32, 1.41, 1.45, 1.49].freeze

        def inconsistency_ratio
          @inconsistency_index ||= inconsistency_index
          @inconsistency_index / RANDOM_INDEX[@n-1]
        end
    
        def cr
          inconsistency_ratio
        end

      end

    end
  end
end