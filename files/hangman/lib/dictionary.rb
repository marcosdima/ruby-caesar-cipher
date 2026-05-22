class Dictionary
  attr_accessor :route
  attr_reader :words

  def initialize(route)
    self.route = route
    @words = Hash.new { |hash, key| hash[key] = [] }
    load
  end

  private def load
    File.foreach(self.route) do |line|
      word = line.chomp
      @words[word.length] << word
    end
  end
end