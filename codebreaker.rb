require "pry-byebug"
require_relative "utils.rb"

class Codebreaker
  attr_reader :human

  include Utils

  def initialize(human = false)
    @human = human
    @potential_codes = all_codes
  end

  def guess(attempt, guess_history)
    if human
      human_guess(attempt)
    else
      computer_guess(attempt, guess_history)
    end
  end

  private

  def human_guess(attempt)
    print "Attempt ##{attempt}: " +
      "Enter four digits (1-6) to guess or 'q' to quit: "
    guess = gets.chomp.strip
    until (guess.length == 4 && all_digits?(guess) &&
           all_chars_between?(guess, '1','6')) || guess == "q" ||
           guess == 'cheat'
      puts "Make sure your guess consists of 4 digits between 1 and 6"
      guess = gets.chomp.strip
    end
    guess
  end

  #"history" entry format: 
  #{ guess: @curr_guess, feedback: @curr_feedback }
  def computer_guess(attempt, history)
    if attempt == 1
      @guess_index = rand(@potential_codes.length)
      @potential_codes[@guess_index]
    elsif attempt == 2
      p history[attempt-2]
      if history[attempt - 2][:feedback].empty?
        @potential_codes.reject! do |code| 
          code.chars.any? do |digit| 
            history[attempt-2][:guess].include?(digit)
          end
        end
        puts "Codes: #{@potential_codes.length}"
      else 
        puts "Borf"
      end
      binding.pry
    else

    end
  end

  def all_codes
    codes = (1111..6666).to_a
    filtered = codes.select{|num| num.to_s.chars.all?{|digit| digit.between?("1","6")}}
    filtered.map{|num| num.to_s}
  end
end
