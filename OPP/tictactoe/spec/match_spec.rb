require_relative '../lib/tictactoe'

describe 'TicTacToe - Match' do
  p1 = TicTacToe::Player.new('Marcos', 'X')
  p2 = TicTacToe::Player.new('Maria', 'O')
  match = TicTacToe::Match.new(p1, p2)
  describe 'Checks if a player has won' do
    it 'Returns nil if there is no winner' do
      expect(match.check_winner).to eq(nil)
    end

    it 'Returns the player that won by a full row, column or diagonal' do
      # Simulate a match where player wins by a full row.
      winner = match.current_player
      match.play(0)
      expect(match.check_winner).to eq(nil)
      match.play(3)
      expect(match.check_winner).to eq(nil)
      match.play(1)
      expect(match.check_winner).to eq(nil)
      match.play(4)
      expect(match.check_winner).to eq(nil)
      match.play(2)
      expect(match.check_winner).to eq(winner)
      
      # Simulate a match where player wins by a full column.
      match.reset
      winner = match.current_player
      match.play(0)
      expect(match.check_winner).to eq(nil)
      match.play(1)
      expect(match.check_winner).to eq(nil)
      match.play(3)
      expect(match.check_winner).to eq(nil)
      match.play(2)
      expect(match.check_winner).to eq(nil)
      match.play(6)
      expect(match.check_winner).to eq(winner)

      # Simulate a match where player wins by a full diagonal.
      match.reset
      winner = match.current_player
      match.play(0) 
      match.play(1)
      match.play(4)
      match.play(2)
      match.play(8)
      expect(match.check_winner).to eq(winner)
    end
  end

  describe 'Checks if the match has ended' do
    it 'Returns true if there is a winner' do
      match.reset
      match.play(0)
      match.play(1)
      match.play(4)
      match.play(2)
      match.play(8)
      expect(match.ended?).to eq(true)
    end

    it 'Returns true if there is a tie' do
      match.reset
      match.play(0)
      match.play(1)
      match.play(2)
      match.play(4)
      match.play(3)
      match.play(5)
      match.play(7)
      match.play(6)
      match.play(8)
      expect(match.ended?).to eq(true)
    end

    it 'Returns false if there is no winner and the match is not a tie' do
      match.reset
      match.play(0)
      match.play(1)
      match.play(2)
      expect(match.ended?).to eq(false)
    end
  end

  describe 'Checks if a move has already been played' do
    it 'Returns true if the move has already been played' do
      match.reset
      match.play(0)
      expect(match.already_played?(0)).to eq(true)
    end

    it 'Returns false if the move has not been played' do
      match.reset
      match.play(0)
      expect(match.already_played?(1)).to eq(false)
    end
  end
end