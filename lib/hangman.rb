require 'json'
require 'pry'

class Solution
  attr_accessor :solution
  def initialize(solution = generate_solution)
    @solution = solution
  end

  def check_guess?(let)
    solution.include?(let)
  end

  def fit_letters(let)
    index = []
    solution.each_with_index { |char, i| index.push(i) if char == let}
    index
  end

  # Private
  def generate_solution
    words = File.read('5desk.txt').downcase.split
    valid = words.each.select { |word| word.length>4 && word.length<13 }
    valid[rand(valid.length-1)].split('')
  end


end

class Board

  def display(misses, display, guessed)

    puts '********************************************************************************'
    print 'Letters guessed:  ' 
    guessed.each {|let| print "#{let} "}
    puts ''
    puts 'Misses Remaining: '+('X '*misses)
    display.each do |let|
      print "#{let} "
    end
    puts ''
    puts '********************************************************************************'
  end
end

class Game

  attr_accessor :solution, :guess, :let_remain, :alphabet, :misses, :display_word, :board, :win
  def initialize(solution, board, misses = 6, guessed = [])
    @solution = solution
    @board = board
    @alphabet = gen_alpha
    @misses = misses
    @guess = ''
    @guessed = guessed
    @display_word = gen_display
    @win = false
    @to_save = false
  end

  def run
    
    board.display(@misses, display_word, @guessed)
    until misses.zero? || @win == true
      @to_save = find_input
      if @to_save
        save_game
        break
      end
      if solution.check_guess?(@guess)
        index = solution.fit_letters(@guess)
        update_display(index, guess)
      else
        @misses -= 1
      end
      if display_word == solution.solution
        @win = true
      end
      board.display(misses, display_word, @guessed)
    end
    ending
    
  end

  # PRIVATE

  def save_game
    temp_hash = {
      "solution" => solution.solution,
      "misses" => "#{@misses}",
      "guessed" => @guessed
    }
    File.open("save.json", "w") do |f|
      f.write(JSON.pretty_generate(temp_hash))
    end
  end

  def ending
    if @to_save == true
      puts 'Your game has been saved!'
    elsif @misses == 0
      puts "You lose! The word was #{solution.solution.join}!"
    else
      puts "You won! Good job!"
    end
  end

  def gen_alpha
    %w[a b c d e f g h i j k l m n o p q r s t u v w x y z]
  end

  def find_input
    puts "Enter your guess(type save to save game): "
    input = gets.chomp.downcase
    return true if input=='save'
    until check_valid?(input)
      puts "Invalid guess, guess again: "
      input = gets.chomp.downcase
    end
    @guess = input
    @guessed.push(input)
    false
  end

  def check_valid?(input)
    alphabet.include?(input) && !@guessed.include?(input)
  end

  def update_display(index, guess)
    index.each do |i|
      display_word[i] = guess
    end
  end

  def gen_display

    word = solution.solution.map do |let|
      @guessed.include?(let) ? let : '_'
    end
    word

  end

end
def load_game
  board = Board.new
  file = File.open "save.json"
  data = JSON.load file
  solution = data["solution"]
  misses = data["misses"].to_i
  guessed = data["guessed"]
  solution = Solution.new(solution)
  Game.new(solution,board,misses,guessed)
end

def new_game
  board = Board.new
  solution = Solution.new
  Game.new(solution, board)
end
def start_game
  
  if File.exist?('save.json')
    puts 'Would you like to load your saved game (y/n)?'
    if gets.chomp.downcase == 'y'
      load_game
    else
      new_game
    end
  else
    new_game
  end
end

keep_playing = true

until !keep_playing
  puts 'Welcome to hangman!'
  game = start_game
  game.run

  puts "Would you like to play again(y/n)?"
  if gets.chomp.downcase != 'y'
    keep_playing = false
  end
end
