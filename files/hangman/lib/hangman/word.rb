module Hangman
  class Word
    attr_reader :guesses

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

    def guessed_correctly?
      (@text.chars - @guesses).empty?
    end

    def to_s
      @text.chars.map { |char| @guesses.include?(char) ? char : '_' }.join(' ')
    end
  end
end