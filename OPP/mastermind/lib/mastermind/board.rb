require_relative 'code'

module Mastermind
  class Board
    attr_reader :colors, :guesses, :try_limit

    def initialize(colors, try_limit)
      @colors = colors
      @try_limit = try_limit
      @guesses = []
      @secret_code = Code.new()
    end

    def set_secret_code(combination)
      @secret_code = Code.new(combination)
      @guesses = [] # Reset guesses when a new secret code is set
    end

    def add_guess(guess)
      unless self.can_guess?
        return
      end

      # We get the feedback for the guess and add it to the list of guesses.
      feedback = @secret_code.feedback(guess)
      @guesses << { guess: guess, feedback: feedback }
    end

    def the_code_was_guessed?
      @guesses.any? { |entry| Code.guessed?(entry[:feedback]) }
    end

    def limit_reached?
      self.guesses.size >= self.try_limit
    end

    def can_guess?
      !@secret_code.empty? && !self.the_code_was_guessed? && !self.limit_reached?
    end

    def remaining_tries
      self.try_limit - self.guesses.size
    end

    def reveal_secret_code
      @secret_code.reveal
    end
  end
end