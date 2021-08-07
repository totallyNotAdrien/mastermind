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
      guess = computer_guess(attempt, guess_history)
      print "Attempt ##{attempt}: #{guess}"
      puts
      guess
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
    prev_guess = (attempt - 2 >= 0) ? history[attempt - 2] : nil
    if attempt == 1
      @guess_index = rand(@potential_codes.length)
      @potential_codes[@guess_index]
    elsif prev_guess
      p prev_guess
      if prev_guess[:feedback].empty?
        @potential_codes.reject! do |code| 
          has_any_digits = code.chars.any? do |digit| 
            prev_guess[:guess].include?(digit)
          end
          is_same = code == prev_guess[:guess]
          has_any_digits && !is_same
        end
        @guess_index = @potential_codes.find_index(prev_guess[:guess])
        @potential_codes.delete_at(@guess_index)
        puts "Codes: #{@potential_codes.length}"
        @guess_index = 0 if @guess_index > @potential_codes.length
        return @potential_codes[@guess_index]
      else 
        #prev_prev_guess needed?
        #something about prev guess and prev prev guess correct and incorrect counts
        #and comparing them
        #more correct in recent means filtering can be done based on digits that changed
        @guess_index += 1
        return @potential_codes[@guess_index]
      end
      #binding.pry
    else

    end
  end

  def all_codes
    codes = (1111..6666).to_a
    filtered = codes.select do |num| 
      num.to_s.chars.all?{|digit| digit.between?("1","6")}
    end
    filtered.map{|num| num.to_s}
  end
end
