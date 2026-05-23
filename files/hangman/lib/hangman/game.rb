require_relative './word'

module Hangman
  class Game
    TRIES = 6
    attr_reader :words_played, :dictionary, :min_length, :max_length, :current_word

    def initialize(dictionary, min_length = 5, max_length = 12)
      @dictionary = dictionary
      @words_played = []
      @current_word = nil
      set_limits(min_length, max_length)
    end

    def set_limits(min_length, max_length)
      # Set word length limits.
      @min_length = min_length
      @max_length = max_length

      # Set remaining words to be those within the limits.
      @available_words = dictionary.words.select do |length, words|
        length >= min_length && length <= max_length
      end.values.flatten
    end

    def pick_word
      # Can not pick a new word until the current word has been guessed correctly or revealed.
      if self.current_word && (!self.current_word.guessed_correctly? && !self.current_word.revealed)
        raise "Current word has not been guessed correctly yet."
      end

      # Check if there are any remaining words to pick from.
      remaining_words = @available_words - self.words_played.map { |word| word.to_s }
      if remaining_words.empty?
        raise "No more words available within the specified length limits."
      end
      
      # Set a new current word from the remaining ones.
      self.current_word = Hangman::Word.new(@available_words.sample)
    end

    def guess_letter(letter)
      letter = letter.downcase
      
      # Word not picked.
      if self.current_word.nil?
        raise "No word has been picked yet."
      end

      # Already guessed.
      if self.current_word.guessed_correctly? || self.current_word.revealed
        raise "Curret word can not be guessed anymore. Please pick a new word."
      end

      # Already guessed this letter.
      if self.current_word.guesses.include?(letter)
        raise "Letter '#{letter}' has already been guessed. Please try a different letter."
      end

      self.current_word.guess(letter)

      # Too many wrong guesses.
      if self.current_word.wrong_guesses.length >= TRIES
        self.current_word.revealed = true
      end
    end

    def status
      {
        current_word: self.current_word ? self.current_word.to_s : nil,
        guesses: self.current_word ? self.current_word.guesses : [],
        wrong_guesses: self.current_word ? self.current_word.wrong_guesses : [],
        words_played: self.words_played.filter do |word|
          word.guessed_correctly? || word.revealed 
        end.map { |word| word.to_s }
      }
    end

    private def current_word=(word)
      @current_word = word
      @words_played << word
    end
  end
end