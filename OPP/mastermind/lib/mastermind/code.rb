module Mastermind
  class Code
    HIT = 'X'
    MISSED = '0'
    WRONG = '-'

    def initialize(colors = [])
      @colors = colors
    end

    def feedback(combination)
      combination.each_with_index.reduce('') do |acc, (color, index)|
        if color == @colors[index]
          acc += HIT
        elsif @colors.include?(color)
          acc += MISSED
        else
          acc += WRONG
        end
      end
    end

    def self.guessed?(feedback)
      feedback.chars.all? { |char| char == HIT }
    end

    def empty?
      @colors.empty?
    end

    def reveal
      @colors
    end
  end
end