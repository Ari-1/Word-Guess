# This is a word guessing game (by Erika & Ari)
# Guess the word before all the petals fall
# use one class for game functionality
require 'colorize'
require 'spicy-proton'


class Game

 def initialize(word)
   @correct_word = word
   @correct_word_array = word.downcase.split("")
   # This take the random word, downcase, and split letters into it's own indexes
   # or elements (interchangable right?)
   @correct_guess = word.gsub(/./ , "_").split("")
# gsub method lets us sub in "-". "/./" is for any characters.
# split method puts "-" into own index or makes them their own elements
   @no_match_guesses = []
   @failed_attempt = 0
 end

 def pedal_remove
   pedal_remove = [
     '''
       (@)(@)(@)(@)(@)
          ,\,\,|,/,/,
            _\|/_
           |_____|
            |   |
            |___|'''.cyan,'''

        (@)(@)(@)(@)
        ,\,\,|,/,/,
            _\|/_
           |_____|
            |   |
            |___|'''.green,'''

          (@)(@)(@)
         ,\,\,|,/,/,
            _\|/_
           |_____|
            |   |
            |___|'''.yellow,'''

           (@)(@)
         ,\,\,|,/,/,
            _\|/_
           |_____|
            |   |
            |___|'''.blue,'''

              (@)
          ,\,\,|,/,/,
             _\|/_
            |_____|
             |   |
             |___|'''.red]
 end

 def promptUser
   unless (@correct_guess.include?("_") )
     puts "\nYOU WIN! THE WORD WAS: #{@correct_word_array.join("")}"
     # if user guess all the letters correctly
      return
   end

   # ask the user to pick a letter
   puts "\nGUESS A LETTER!"
   guess = gets.chomp.downcase

   # prints guesses to user followed by comma
   puts "YOUR GUESSES SO FAR: #{@no_match_guesses.join(', ')}"

   # let the user know if they can't have more than one letter
     if (guess.length > 1)
       puts "\nYOU HAVE TO GUESS THE WORD OR ONE LETTER AT A TIME."
       return promptUser
     end

   # let the user know it has to be a letter
   unless (guess.match(/[a-zA-Z]/))
     puts "\nSORRY. MUST BE A LETTER"
     return promptUser
   end

   # if letter guessed is already picked
   if (@no_match_guesses.include?(guess))
     puts "\nYOU'VE ALREADY GUESSED THIS LETTER: #{guess}"
     pedal_remove
     return promptUser
   end
   # track of all the letters guessed
   @no_match_guesses.push(guess)

   # if the users letter is in the word
   if (@correct_word_array.include?(guess)) #from index [0] to last index of word
     0.upto(@correct_word_array.length-1) { |index|
       if (@correct_word_array[index] == guess)
         @correct_guess[index] = guess
       end
     }
       puts "SECERT WORD: #{@correct_guess.join('  ')}"
     promptUser # return to the prompt method to guess another letter
     pedal_remove # remove petals from the picture
   else
       puts "SECERT WORD: #{@correct_guess.join('  ')}"
     @failed_attempt += 1
     # if the user loses all of its chances to answer
     if (@failed_attempt == 6)
       puts "\nSORRY! YOU LOSE, THE ANSWER IS #{@correct_word_array.join("")}!"
       return
   else
       puts pedal_remove[@failed_attempt-1]
       return promptUser
     end
   end
 end
end

# make sure to not use the same word twice in game
  def dont_repeat(array)
      array.delete_at(rand(array.length))
  end

# list of secert words to guess

puts "Welcome to our guessing game!"
print "Would you like to continue? (yes/no) "
answer = gets.chomp.downcase

# continue the game as long as there are words to use
while answer == "yes"

  print "\nWhat level would you like? (easy, medium, hard): "
  level = gets.chomp.downcase

  while !(level == "easy" || level == "medium" || level == "hard")
    puts "\nSorry. Please pick a level:"
    level = gets.chomp.downcase
  end

  case level
  when "easy"
    myGame = Game.new(Spicy::Proton.noun(max: 3))
    myGame.promptUser
  when "medium"
    myGame = Game.new(Spicy::Proton.noun(max: 6))
    myGame.promptUser
  when "hard"
    myGame = Game.new(Spicy::Proton.noun(max: 10))
    myGame.promptUser
  end

  print "\nWould you like to continue? "
  answer = gets.chomp.downcase
end
