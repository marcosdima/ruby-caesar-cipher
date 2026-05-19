module TicTacToe
  class Piece
    attr_reader :value

    def initialize(char)
      @value = char
    end

    def ==(other)
      self.value == other.value
    end

    def to_s
      self.value
    end
  end
end