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
end