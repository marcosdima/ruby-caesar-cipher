require_relative '../lib/mastermind'

describe 'Testing code' do
  describe 'Guessing the code' do
    let(:red) { Mastermind::Color.new('Red', 'R') }
    let(:blue) { Mastermind::Color.new('Blue', 'B') }
    let(:green) { Mastermind::Color.new('Green', 'G') }
    let(:yellow) { Mastermind::Color.new('Yellow', 'Y') }

    it 'if the combination of colors matches the secret code, returns X (Code HIT constant) n times' do
      code = Mastermind::Code.new([red, blue, yellow, green])
      guess = [red, blue, yellow, green]
      feedback = code.feedback(guess)
      expect(feedback).to eq('XXXX')
    end

    it 'if the combination of colors has the right colors but in the wrong position, returns 0 (Code MISSED constant) n times' do
      code = Mastermind::Code.new([red, blue, yellow, green])
      guess = [blue, red, green, yellow]
      feedback = code.feedback(guess)
      expect(feedback).to eq('0000')
    end

    it 'if the combination of colors has colors that are not in the secret code, returns - (Code WRONG constant) n times' do
      code = Mastermind::Code.new([red, blue, green])
      guess = [yellow, yellow, yellow]
      feedback = code.feedback(guess)
      expect(feedback).to eq('---')
    end

    it 'it can be a combination of hits, misses and wrongs' do
      code = Mastermind::Code.new([red, blue, blue, yellow])
      guess = [red, green, yellow, green]
      feedback = code.feedback(guess)
      expect(feedback).to eq('X-0-')
    end
  end
end