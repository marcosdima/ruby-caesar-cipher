module TicTacToe
  class Player
    attr_reader :name, :piece

    def initialize(name, piece_char)
      @name = name
      @piece = Piece.new(piece_char)
    end
  end
end
