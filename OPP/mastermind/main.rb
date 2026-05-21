require_relative 'lib/mastermind'
require 'io/console'

RED = Mastermind::Color.new('Red', 'R')
BLUE = Mastermind::Color.new('Blue', 'B')
GREEN = Mastermind::Color.new('Green', 'G')
YELLOW = Mastermind::Color.new('Yellow', 'Y')
COLORS = [RED, BLUE, GREEN, YELLOW]

TITLE = "Mastermind\n"
ICONS = "
#{Mastermind::Code::HIT} - Correct color and position
#{Mastermind::Code::MISSED} - Correct color but wrong position
#{Mastermind::Code::WRONG} Wrong color
"

def show_board(board)
  res = "\n"
  res += "Remaining tries: #{board.remaining_tries}\n"
  res += "Guesses:\n"
  board.guesses.each do |guess|
    res += "  #{guess[:guess].join('-')} - #{guess[:feedback].split.join(' ')}\n"
  end
  
  res
end

def clear_screen
  system(Gem.win_platform? ? "cls" : "clear")
end

def select_colors_by_index(prev_text = '')
  selected = 0
  exit = false

  until exit
    clear_screen
    puts prev_text unless prev_text.empty?
    puts

    colors = COLORS.map do |color|
      if color != COLORS[selected]
        color.name
      else
        color.name.upcase
      end
    end

    puts "Available colors: #{colors.join(', ')}"
    puts "Selected color: #{colors[selected]}"
    puts
    puts 'Press enter to select, move the arrow keys to change selection.'

    input = STDIN.getch
    if input == "\e"
      input << STDIN.read_nonblock(2)

      case input
        when "\e[C" # Right arrow
          selected = (selected + 1) % COLORS.size
        when "\e[D" # Left arrow
          selected = (selected - 1) % COLORS.size
      end
    elsif input == "\r" # Enter key
      exit = true
    end
  end

  selected
end

def write_code(prev_text = '', limit = 4)
  code = []
  until code.size == 4
    selected_index = select_colors_by_index(prev_text + "\nSelected colors: #{code.map(&:name).join(', ')}\n")
    code << COLORS[selected_index]
  end
  code
end

clear_screen
puts 'Welcome to MasterMind'
puts

try_limit = nil
until try_limit
  puts "Select the number of tries:"
  try_limit = gets.chomp.to_i
end

board = Mastermind::Board.new(COLORS, try_limit)

secret_code = write_code("Select the secret code\n")
board.set_secret_code(secret_code)

while board.can_guess?
  clear_screen
  guess = write_code(TITLE + ICONS + show_board(board))
  board.add_guess(guess)
end

clear_screen
puts TITLE + show_board(board)
puts
if board.the_code_was_guessed?
  puts "Congratulations! You've guessed the code!"
else
  puts "Game over! You've reached the try limit. The secret code was: #{board.reveal_secret_code.map{ |color| color.name }.join(', ')}"
end
