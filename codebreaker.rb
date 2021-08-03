require_relative "utils.rb"

class Codebreaker
  attr_reader :human

  include Utils

  def initialize(human = false)
    @human = human
  end

  def guess()
    if human
      human_guess
    end
  end

  private

  def human_guess()
    puts "Enter four digits (1-6) to guess or 'q' to quit"
    guess = gets.chomp.strip
    until (guess.length == 4 && all_digits?(guess) &&
           all_chars_between?(guess, '1','6')) || guess == "q" ||
           guess == 'cheat'
      puts "Make sure your guess consists of 4 digits between 1 and 6"
      guess = gets.chomp.strip
    end
    guess
  end
end
