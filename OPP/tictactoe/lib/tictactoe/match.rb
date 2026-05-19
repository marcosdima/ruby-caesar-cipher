require_relative 'piece'
require_relative 'table'

module TicTacToe
  class Match
    attr_reader :players, :table, :turn_of

    def initialize(player1 = Player.new('Player 1', 'x'), player2 = Player.new('Player 2', 'o'))
      @players = [player1, player2]
      @table = TicTacToe::Table.new
    end

    def play(position)
      x = position / 3
      y = position % 3
      self.table.set_coord(x, y, self.current_player.piece)
      @turn_of = (self.turn_of + 1) % 2
    end

    def there_is_a_winner?
      false
    end

    def current_player
      self.players[self.turn_of]
    end
  end
end