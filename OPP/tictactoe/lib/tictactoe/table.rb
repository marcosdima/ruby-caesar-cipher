module TicTacToe
  class Table
    attr_reader :matrix

    def initialize
      self.set_matrix
    end

    def show
      line = '-----'
      puts line

      matrix.length.times do |i|
        matrix[i].each_with_index do |value, j|
          if value
            print value
          else
            print ' '
          end
          unless j == 2
            print '|'
          end
        end
        puts
        puts line
      end
    end

    def set_coord(x, y, piece) 
      @matrix[x][y] = piece.value
    end

    def set_matrix
      @matrix = Array.new(3) { Array.new(3) }
    end
  end
end