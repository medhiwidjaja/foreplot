require 'matrix'

module Foreplot
  # AHP Module contains the classes for modeling and calculating decision hierarchy using the AHP
  # (Analytic Hierarchy Process) method.
  # For background theory, see http://en.wikipedia.org/wiki/Analytic_hierarchy_process
  module AHP

    class AHPMatrix
      attr_reader :matrix, :n, :eigenvalues, :eigenvectors

      def initialize(values, n)
        @n = n
        if values.is_a? Matrix
          @matrix = init_with_matrix(values, n) 
        elsif values.kind_of? Array
          @matrix = init_with_array(values, n)
        else
          raise ArgumentError, "First argument to AHPMatrix is not a matrix or an array."
        end
        @eigenvectors = @matrix.eigen.eigenvectors
        @eigenvalues = @matrix.eigen.eigenvalues
      end

      # Pretty print the matrix. For debugging purpose only. 
      def pp
        (0..@n-1).each {|i| print "[ "; (0..@n-1).each {|j| printf(" %0.03f ", @matrix.row(i)[j])}; print " ]\n"}
      end

      private

      # Number of elements in strict upper half of the matrix required to create a reciprocal matrix
      def number_of_elements(n) 
        ((n**2)-n)/2 
      end

      def init_with_matrix(matrix, n)
        raise ArgumentError, "Matrix argument is not a square matrix." unless matrix.square?
        raise ArgumentError, "Matrix size is different from the size argument" unless matrix.column_size == n
        @matrix = matrix
      end

      def init_with_array(values, n)
        # Accept array of numbers of each element of **the upper half** of the matrix above the diagonal line.
        # The diagonal and lower half will be created.
        # Size of the array has to be equal to number_of_elements(n)
        raise ArgumentError, "Number of array elements doesn't match the specified matrix size." unless values.count == number_of_elements(n)
        i = 0
        matrix_array = []
        (0..n-1).each do |row|
          matrix_array << []
          (0..n-1).each do |col|
            if row == col
              matrix_array[row][col] = 1.0
            elsif row < col # above the diagoal
              matrix_array[row][col] = values[i]
              i += 1
            else # row > col
              matrix_array[row][col] = 1.0/matrix_array[col][row]
            end              
          end
        end
        @matrix = Matrix.build(n) { |row, col| matrix_array[row][col] }
      end
    end

  end
end