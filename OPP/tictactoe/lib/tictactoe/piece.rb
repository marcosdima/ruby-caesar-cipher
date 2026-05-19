module TicTacToe
  class Piece
    attr_reader :value

    def initialize(char)
      @value = char
    end

    def ==(other)
      self.value == other.value
    end
  end
end