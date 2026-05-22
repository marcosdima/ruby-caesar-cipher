require_relative '../lib/hangman'

describe 'Testing word' do
  it 'At first, the guesses array should be empty' do
    word = Hangman::Word.new('test')
    expect(word.guesses).to be_empty
  end

  describe 'Should allow guesses' do
    it 'If the guess is a single letter, it should be added to the guesses array' do
      word = Hangman::Word.new('test')
      word.guess('t')
      expect(word.guesses).to include('t')
    end

    it 'If the guess is not a single letter, it should raise an error' do
      word = Hangman::Word.new('test')
      expect { word.guess('te') }.to raise_error(ArgumentError)
    end
  end

  describe 'Should return wrong guesses' do
    it 'If the letter guessed is not in the word, it should be included in the wrong guesses' do
      word = Hangman::Word.new('test')
      word.guess('a')
      expect(word.wrong_guesses).to include('a')
    end

    it 'If the letter guessed is in the word, it should not be included in the wrong guesses' do
      word = Hangman::Word.new('test')
      word.guess('t')
      expect(word.wrong_guesses).not_to include('t')
    end
  end

  describe 'Should return the correct string representation of the word' do
    it 'If no letters have been guessed, it should return underscores for each letter' do
      word = Hangman::Word.new('test')
      expect(word.to_s).to eq('_ _ _ _')
    end

    it 'If some letters have been guessed, it should return those letters and underscores for the rest' do
      word = Hangman::Word.new('test')
      word.guess('t')
      expect(word.to_s).to eq('t _ _ t')
    end

    it 'If all letters have been guessed, it should return the full word' do
      word = Hangman::Word.new('test')
      word.guess('t')
      word.guess('e')
      word.guess('s')
      expect(word.to_s).to eq('t e s t')
    end
  end

  describe 'Should determine if the word has been guessed correctly' do
    it 'If all letters in the word have been guessed, it should return true' do
      word = Hangman::Word.new('test')
      word.guess('t')
      word.guess('e')
      word.guess('s')
      expect(word.guessed_correctly?).to be true
    end

    it 'If not all letters in the word have been guessed, it should return false' do
      word = Hangman::Word.new('test')
      word.guess('t')
      word.guess('e')
      expect(word.guessed_correctly?).to be false
    end
  end

  describe 'Should allow revealing the word' do
    it 'If the word is revealed, to_s should return the full word' do
      word = Hangman::Word.new('test')
      word.revealed = true
      expect(word.to_s).to eq('test')
    end
  end
end