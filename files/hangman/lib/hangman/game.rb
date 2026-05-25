require_relative '../serialize'
require_relative './word'

module Hangman
  class Game
    include BasicSerializable

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
      @current_word = Hangman::Word.new(@available_words.sample)
    end

    def guess_letter(letter)
      letter = letter.downcase

      # Validate input.
      unless letter.length == 1 && letter.match?(/[a-z]/)
        raise ArgumentError, 'Guess must be a single letter (a-z)'
      end
      
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

      if self.current_word.guessed_correctly? || self.current_word.revealed
        @words_played << self.current_word
      end
    end

    # Serialization #
    def exclude_from_serialization
      [:@dictionary, :@available_words]
    end

    def serialize
      obj = {}
      excluded = exclude_from_serialization

      instance_variables.map do |var|
        next if excluded.include?(var)

        value = instance_variable_get(var)
        case var
          when :@current_word
            obj[var] = value.serialize
          when :@words_played
            obj[var] = value.map { |word| word.serialize }
          else
            obj[var] = value
        end
      end

      @@serializer.dump obj
    end

    def unserialize(string)
      obj = @@serializer.parse(string)
      excluded = exclude_from_serialization

      obj.keys.each do |key|
        next if excluded.include?(key)

        value = obj[key]
        case key
          when "@current_word"
            instance_variable_set(key, unserialize_word(value))
          when "@words_played"
            instance_variable_set(key, value.map { |word_data| unserialize_word(word_data) })
          else
            instance_variable_set(key, obj[key])
        end
      end
    end

    private def unserialize_word(word_data)
      word = Hangman::Word.new('')
      word.unserialize(word_data)
      word
    end
  end
end