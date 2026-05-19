require_relative 'piece'
require_relative 'table'

module TicTacToe
  class Match
    attr_reader :players, :table, :turn_of, :plays

    def initialize(player1, player2)
      @players = [player1, player2]
      @table = TicTacToe::Table.new
      @turn_of = rand(2)
      @plays = []
      self.table.set_matrix
    end

    def play(input)
      x = input / 3
      y = input % 3
      self.table.set_coord(x, y, self.current_player.piece)
      @turn_of = (self.turn_of + 1) % 2
      @plays.push(input)
    end

    def check_winner
      p1_win = self.players.first.piece.value * 3
      p2_win = self.players.last.piece.value * 3

      matrix = self.table.matrix

      # Check diagonals.
      diagonal1 = ''
      diagonal2 = ''

      for i in 0..2
        # Accumulate diagonals.
        diagonal1 += matrix[i][i].to_s
        diagonal2 += matrix[i][2-i].to_s

        # Clean row and column strings.
        row = ''
        column = ''

        for j in 0..2
          row += matrix[i][j].to_s  
          column += matrix[j][i].to_s
        end

        # Check row and column.
        if row == p1_win || column == p1_win
          return self.players.first
        elsif row == p2_win || column == p2_win
          return self.players.last
        end
      end

      # Check diagonals.
      if diagonal1 == p1_win || diagonal2 == p1_win
        return self.players.first
      elsif diagonal1 == p2_win || diagonal2 == p2_win
        return self.players.last
      end

      # None of the players won.
      nil
    end

    def current_player
      self.players[self.turn_of]
    end

    def already_played?(input)
      self.plays.include?(input)
    end

    def reset
      self.table.set_matrix
      @plays = []
      @turn_of = rand(2)
    end

    def ended?
      self.plays.length == 9 || self.check_winner != nil
    end
  end
end