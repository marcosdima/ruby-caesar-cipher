require_relative 'lib/tictactoe'

def log_error(message)
  error_message = "- Error: #{message} -"
  line = Array.new(error_message.length, '-').join
  
  puts line
  puts error_message
  puts line
end

def clear_screen
  system(Gem.win_platform? ? "cls" : "clear")
end

def loop_game(match)
  error_aux = nil
  playing = true

  while playing
    # Clean screen.
    self.clear_screen

    # If there is an error, log it.
    if error_aux
      self.log_error(error_aux)
      error_aux = nil
    end

    # Show current table.
    puts 'Current table:'
    match.table.show
    
    # Ask for input.
    puts "Turn of #{match.current_player.name} (#{match.current_player.piece}): "
    
    # Validate input.
    input = gets.chomp.to_i
    unless input >= 1 && input <= 9
      error_aux = 'Input must be a number between 1 and 9'
      next
    end

    # Validate try.
    adjusted_input = input - 1
    if match.already_played?(adjusted_input)
        error_aux = "Already played!"
      next
    end

    # Play.
    match.play(adjusted_input)

    # Check if there is the match ended.
    if match.ended?
      clear_screen
      match.table.show

      winner = match.check_winner

      puts
      if winner.nil?
        puts "It's a tie!"
      else
        puts "Congratulations #{winner.name}!"
      end
      puts

      playing = false
    end
  end
end

running = true
player1 = nil
player2 = nil

while running
  puts "Welcome to Tic Tac Toe!"
  puts "1. Play"
  puts "2. Exit"

  option = gets.chomp
  clear_screen

  case option
  when "1"
    puts "Starting match..."
    puts

    unless player1 && player2
      puts "Player 1 name: "
      player1_name = gets.chomp
      player1 = TicTacToe::Player.new(player1_name, "X")

      puts "Player 2 name: "
      player2_name = gets.chomp
      player2 = TicTacToe::Player.new(player2_name, "O")
    end
    
    loop_game(TicTacToe::Match.new(player1, player2))
  when "2"
    running = false
  else
    puts "Invalid option"
  end
end