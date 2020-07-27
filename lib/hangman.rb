
require 'pry'

class Solution
  attr_accessor :solution
  def initialize(solution = generate_solution)
    @solution = solution
  end

  def check_guess?(let)
    solution.include?(let)
  end

  def fit_letters
    

  def gen_display
    blanks = solution.map{ |let| "_ " }
    blanks
  end

  # Private
  def generate_solution
    words = File.read('5desk.txt').downcase.split
    valid = words.each.select { |word| word.length>4 && word.length<13 }
    valid[rand(valid.length-1)].split('')
  end


end

class Board

  def display(misses, display)
    puts '*************************************'
    puts 'Misses Remaining: '+('X '*misses)
    display.each do |let|
      print "#{let} "
    end
    puts ''
    puts '*************************************'
  end
end

class Game

  attr_accessor :solution, :guess, :let_remain, :alphabet, :misses, :display_word, :board, :win
  def initialize(solution, board)
    @solution = solution
    @board = board
    @guess = ''
    @let_guessed = []
    @alphabet = gen_alpha
    @misses = 6
    @display_word = solution.gen_display
    @win = false
  end

  def run
    puts "Welcome to hangman!"
    board.display(misses,display_word)
    until misses == 0 || win == true
      guess = find_input
      if check_guess?
        index = fit_letters
        update_display
      else
        misses -= 1
      end
      board.display(misses,display_word)
      win = true
    end

  end
  # PRIVATE
  def gen_alpha
    %w[a b c d e f g h i j k l m n o p q r s t u v w x y z]
  end

  def find_input
    puts "Enter your guess: "
    input = gets.chomp.downcase
    until check_valid?(input)
      puts "Invalid guess, guess again: "
      input = gets.chomp.downcase
    end
    input
  end

  def check_valid?(input)
    return alphabet.include?(input)
  end

  def update_display(index)
    index.each 
  end

end
board = Board.new
solution = Solution.new
game = Game.new(solution,board)
game.run
