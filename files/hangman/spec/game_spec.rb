require_relative '../lib/hangman'

def reveal_word(game)
  letter = 'a'
  Hangman::Game::TRIES.times { game.guess_letter(letter); letter = (letter.ord + 1).chr }
end

describe 'Testing Game' do
  let(:dictionary) { Hangman::Dictionary.new('./files/google-10000-english-no-swears.txt') }
  let(:game) { Hangman::Game.new(dictionary) }
  
  it 'Initializes with a dictionary and default limits' do
    expect(game.dictionary).to eq(dictionary)
    expect(game.words_played).to eq([])
    expect(game.min_length).to eq(5)
    expect(game.max_length).to eq(12)
  end

  describe 'It should let you set limits' do
    it 'Should set the min and max length limits' do
      game.set_limits(3, 8)
      expect(game.min_length).to eq(3)
      expect(game.max_length).to eq(8)
    end
  end

  describe 'It should let pick a word' do
    it 'Should pick a word within the specified limits' do
      game.pick_word
    end

    it 'Should not pick a new word until the current one is guessed correctly' do
      game.pick_word
      expect { game.pick_word }.to raise_error(RuntimeError)
    end
  end

  describe 'It should let guess a letter' do
    it 'Should not let guess if no word has been picked' do
      expect { game.guess_letter('a') }.to raise_error(RuntimeError)
    end

    it 'Should not let guess if the current word has already been guessed correctly' do
      game.pick_word
      game.guess_letter('a')
      expect { game.guess_letter('a') }.to raise_error(RuntimeError)
    end

    it 'Should not let guess if the current word has already been guessed incorrectly too many times' do
      game.pick_word

      letter = 'a'
      while !game.current_word.revealed
        game.guess_letter(letter)
        letter = (letter.ord + 1).chr
      end

      expect { game.guess_letter('a') }.to raise_error(RuntimeError)
    end

    it 'If the letter has already been guessed, it should not let guess it again' do
      game.pick_word
      game.guess_letter('a')
      expect { game.guess_letter('a') }.to raise_error(RuntimeError)
    end

    it 'If the letter was uppercase, it should be treated as lowercase' do
      game.pick_word
      game.guess_letter('A')
      expect(game.current_word.guesses).to include('a')
    end
  end
end