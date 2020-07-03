require 'matrix'

module Foreplot
  module Decision 

    # AHP Module contains the classes for modeling and calculating decision hierarchy using the AHP
    # (Analytic Hierarchy Process) method.
    # For background theory, see http://en.wikipedia.org/wiki/Analytic_hierarchy_process
    module Ahp

      # AhpMatrix embodies a single decision node in the decision hierarchy.
      # There are two methods to initialize it:
      #   1) node = AHP::AHPMatrix.new(matrix, n)
      #      matrix must be a square matrix of dimension n*n. matrix must be in the form of reciprocal matrix
      #      suitable for AHP calculation. No checking is made whether the matrix is really reciprocal matrix.
      #      Example: 
      #        matrix = Matrix[[1.0, 1/4.0, 4, 1/6.0], [4.0, 1.0, 4, 1/4.0], [1/4.0, 1/4.0, 1.0, 1/5.0], [6.0, 4.0, 5.0, 1.0]]
      #        node = AHP::AHPMatrix.new(matrix, 4)
      #   2) node = AHP::AHPMatrix.new(ary, n)
      #      ary is an array containing the elements of the upper half above the diagonal of the matrix.
      #      n is the dimension of the square matrix.
      #      The number of elements in the array must be equal to ((n**2)-n)/2
      #      For example, the AHPMatrix above could also be initialized in the following way
      #        node = AHP::AHPMatrix.new([1/4.0, 4, 1/6.0, 4, 1/4.0, 1/5.0], 4)
      #
      class AhpMatrix
        attr_reader :matrix, :n, :eigenvectors, :eigenvalues

        def initialize(matrix, n)
          if matrix.class == Matrix
            raise MatrixNotSquareError unless matrix.square?
            @matrix = matrix
            raise MatrixSizeMismatch unless matrix.column_size == n
            @n = n
          elsif matrix.class == Array
            # Accept array of numbers of each element of the upper half of the matrix above the diagonal line.
            # Size of the array has to be equal to number_of_elements(n)
            raise ArrayElementsSizeMismatch unless matrix.count == number_of_elements(n)
    
            i = 0
            matrix_array = []
    
            (0..n-1).each do |row|
              matrix_array << []
              (0..n-1).each do |col|
                if row == col
                  matrix_array[row][col] = 1.0
                elsif row < col # above the diagoal
                  matrix_array[row][col] = matrix[i]
                  i += 1
                else # row > col
                  matrix_array[row][col] = 1.0/matrix_array[col][row]
                end              
              end
            end
            @matrix = Matrix.build(n) { |row, col| matrix_array[row][col] }
          else
            raise ArgumentDataTypeError
          end
          @n = n
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
        
      end

      class ArgumentDataTypeError < ArgumentError
        #  "First argument to AHPMatrix is not a matrix or an array."
      end
    
      class ArrayElementsSizeMismatch < ArgumentError
        #  "Number of array elements doesn't match the specified matrix size."
      end
    
      class MatrixNotSquareError < ArgumentError
        #  "Matrix argument is not a square matrix."
      end
    
      class MatrixSizeMismatch < ArgumentError
        #  "Matrix size is different from the size argument"
      end

    end
  end
end