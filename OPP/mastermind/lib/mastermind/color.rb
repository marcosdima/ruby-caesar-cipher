module Mastermind
  class Color
    attr_reader :name, :code

    def initialize(name, code)
      @name = name
      @code = code
    end

    def ==(other)
      other.is_a?(Color) && name == other.name && code == other.code
    end

    def to_s
      name
    end
  end
end