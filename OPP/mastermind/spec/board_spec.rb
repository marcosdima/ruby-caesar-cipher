require_relative '../lib/mastermind'

describe 'Testing board' do
  let(:red) { Mastermind::Color.new('Red', 'R') }
  let(:blue) { Mastermind::Color.new('Blue', 'B') }
  let(:green) { Mastermind::Color.new('Green', 'G') }
  let(:yellow) { Mastermind::Color.new('Yellow', 'Y') }
  let(:orange) { Mastermind::Color.new('Orange', 'O') }
  let(:colors) { [red, blue, green, yellow, orange] }
  let(:board) { Mastermind::Board.new(colors, 5) }

  describe 'Adding guesses' do
    it 'adds a guess to the board' do
      board.set_secret_code([red, blue, green])
      guess = [red, blue, yellow]
      board.add_guess(guess)
      expect(board.guesses.size).to eq(1)
      expect(board.guesses.first[:guess]).to eq(guess)
      expect(board.guesses.first[:feedback]).to eq('XX-')
    end

    it 'does not add a guess if the try limit has been reached' do
      board.set_secret_code([green, blue, green])
      5.times { board.add_guess([red, red, red]) }
      expect(board.guesses.size).to eq(5)
      board.add_guess([red, red, red])
      expect(board.guesses.size).to eq(5) # No new guess added
    end
  end

  describe 'Checking if the code was guessed' do
    it 'returns true if the code was guessed' do
      board.set_secret_code([red, blue, green])
      board.add_guess([red, blue, green])
      expect(board.the_code_was_guessed?).to be true
    end

    it 'returns false otherwise' do
      board.set_secret_code([red, blue, green])
      board.add_guess([red, red, red])
      expect(board.the_code_was_guessed?).to be false
    end
  end
end