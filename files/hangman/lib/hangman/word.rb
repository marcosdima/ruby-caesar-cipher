module Hangman
  class Word
    attr_reader :text, :guesses

    def initialize(text)
      @text = text
      @guesses = []
    end

    def guess(letter)
      unless letter.length == 1
        raise ArgumentError, 'Guess must be a single letter'
      end
      @guesses << letter
    end

    def wrong_guesses
      @guesses - @text.chars
    end
  end
end