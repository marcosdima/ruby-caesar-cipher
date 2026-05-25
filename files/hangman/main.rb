require_relative 'lib/hangman'

def clean_screen
  system("clear") || system("cls")
end

def show_game_status(game)
  clean_screen
  wrong_guesses = game.current_word.wrong_guesses
  puts "Current word: #{game.current_word.to_s}"
  puts "Wrong guesses: #{wrong_guesses.join(', ')}"
  puts "Tries left: #{Hangman::Game::TRIES - wrong_guesses.length}"
end

def play(game)
  # Game loop
  game.pick_word
  until game.current_word.guessed_correctly? || game.current_word.revealed
    show_game_status(game)
    print "Enter a letter to guess: "
    letter = gets.chomp
    begin
      game.guess_letter(letter)
    rescue => e
      puts
      puts e.message
      press_any_key
    end
  end

  clean_screen
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
  clean_screen
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

dic = Hangman::Dictionary.new('./files/google-10000-english-no-swears.txt')
game = Hangman::Game.new(dic)

puts "Welcome to Hangman!"

exit = false
until exit
  clean_screen

  puts "1. Pick a new word"
  puts "2. Load previous match"
  puts "3. Show previous words"
  puts "Any other key. Exit"
  print "Enter your choice: "
  choice = gets.chomp

  case choice
  when "1"
    # Pick a new word
    play(game)
  when "2"
    # Load previous match
  when "3"
    # Show previous words
    show_previous_words(game)
  else
    exit = true
  end
end