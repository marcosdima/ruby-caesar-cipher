require_relative '../serialize'

module Hangman
  class Word
    include BasicSerializable
    
    attr_accessor :revealed
    attr_reader :guesses

    def initialize(text)
      @text = text
      @guesses = []
      self.revealed = false
    end

    def guess(letter)
      @guesses << letter
    end

    def wrong_guesses
      @guesses - @text.chars
    end

    def guessed_correctly?
      (@text.chars - @guesses).empty?
    end

    def to_s
      if self.guessed_correctly? || self.revealed
        @text
      else
        @text.chars.map { |char| @guesses.include?(char) ? char : '_' }.join(' ')
      end
    end
  end
end