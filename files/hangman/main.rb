require_relative 'lib/hangman'

def clear_screen
  system("clear") || system("cls")
end

def show_game_status(game)
  clear_screen
  wrong_guesses = game.current_word.wrong_guesses
  puts "Current word: #{game.current_word.to_s}"
  puts "Wrong guesses: #{wrong_guesses.join(', ')}"
  puts "Tries left: #{Hangman::Game::TRIES - wrong_guesses.length}"
end

def play(game)
  # Game loop
  until game.current_word.guessed_correctly? || game.current_word.revealed
    show_game_status(game)
    print "Enter a letter to guess ('save' to save the game and leave): "
    letter = gets.chomp
    
    if letter.downcase == 'save'
      puts
      puts "Saving game and exiting..."
      save_game(game)
      return # Exit the game loop after saving
    end

    begin
      game.guess_letter(letter)
    rescue => e
      puts
      puts e.message
      press_any_key
    end
  end

  clear_screen

  if game.current_word.guessed_correctly?
    puts "Congratulations! You've guessed the word: #{game.current_word.to_s}"
  else
    puts "Game over! The word was: #{game.current_word.to_s}"
  end

  # Play again?
  puts
  puts "Do you want to play again? (y/n)"
  play_again = gets.chomp.downcase
  play(game) if play_again == 'y'
end

def show_previous_words(game)
  clear_screen
  if game.words_played.empty?
    puts "No previous words played yet."
  else
    puts "Previous words played:"
    game.words_played.each_with_index do |word, index|
      print "#{index + 1}. #{word} - "
      print "#{word.guessed_correctly? ? 'Guessed' : 'Not Guessed'} - "
      print "Guesses: #{game.current_word.guesses.join(', ')}."
      puts
    end
  end
  press_any_key
end

def press_any_key
  puts
  puts "Press any key to continue..."
  gets
end

def save_game(game)
  # Save current match.
  clear_screen

  puts
  puts "Saving current match..."
  puts
  puts 'Select a save name: '

  name = gets.chomp.strip

  # Create saves directory if it doesn't exist and save the game state to a file.
  Dir.mkdir('saves') unless Dir.exist?('saves')

  # Save the game state to a file.
  File.open("saves/#{name.empty? ? 'default' : name}.json", 'w') do |file|
    file.write(game.serialize)
  end
end

def load_game(game)
  clear_screen

  dir_file_names = Dir.entries('saves').select { |f| File.file?(File.join('saves', f)) }
  if dir_file_names.empty?
    puts "No saved games found."
    press_any_key
    return
  end

  dir_file_names.each_with_index do |file_name, index|
    puts "#{index + 1}. #{file_name}"
  end

  puts
  print "Enter the number of the save to load: "
  choice = gets.chomp.to_i
  if choice < 1 || choice > dir_file_names.length
    puts "Invalid choice."
    press_any_key
    return
  end

  selected_file = dir_file_names[choice - 1]
  file_path = File.join('saves', selected_file)
  game.unserialize(File.read(file_path))
end

dic = Hangman::Dictionary.new('./files/google-10000-english-no-swears.txt')
game = Hangman::Game.new(dic)

puts "Welcome to Hangman!"

exit = false
initializated = false

until exit
  clear_screen

  puts "1. Pick a new word"
  puts "2. Show previous words"
  puts "3. Load previous match"
  initializated ? puts("4. Save current match") : nil
  
  puts
  puts "Any other key. Exit"
  print "Enter your choice: "

  choice = gets.chomp

  case choice
  when "1"
    # Pick a new word.
    initializated = true
    game.pick_word
    play(game)
  when "2"
    # Show previous words.
    show_previous_words(game)
  when "3"
    # Load previous match.
    load_game(game)

    # Play loaded match.
    initializated = true
    game.pick_word if game.current_word.revealed || game.current_word.guessed_correctly?
    play(game)
  when "4"
    initializated ? nil : next
    save_game(game)
  else
    exit = true
  end
end