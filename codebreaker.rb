require "pry-byebug"
require_relative "utils.rb"

class Codebreaker
  attr_reader :human

  CORRECT = "C"
  INCORRECT_PLACEMENT = "I"

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
           all_chars_between?(guess, "1", "6")) || guess == "q" ||
          guess == "cheat"
      puts "Make sure your guess consists of 4 digits between 1 and 6"
      guess = gets.chomp.strip
    end
    guess
  end

  #"history" entry format:
  #{ guess: @curr_guess, feedback: @curr_feedback }
  def computer_guess(attempt, history)
    prev_guess = history.last
    penultimate_guess =
      (history.length >= 2) ? history[history.length - 2] : nil

    if prev_guess && penultimate_guess
      puts penultimate_guess
      puts prev_guess
      #something about prev guess and penultimate_guess correct and incorrect counts
      #and comparing them
      #more correct in recent means filtering can be done based on digits that changed
      @guess_index = (@guess_index + 1) % @potential_codes.length
      return @potential_codes[@guess_index]
    elsif prev_guess
      p prev_guess
      if prev_guess[:feedback].empty?
        reject_all_digits_except_exact_match(prev_guess)
        return next_potential_code(prev_guess)
      else
        @guess_index = (@guess_index + 1) % @potential_codes.length
        return @potential_codes[@guess_index]
      end
      #binding.pry
    else
      @guess_index = rand(@potential_codes.length)
      @potential_codes[@guess_index]
    end
  end

  def all_codes
    codes = (1111..6666).to_a
    filtered = codes.select do |num|
      num.to_s.chars.all? { |digit| digit.between?("1", "6") }
    end
    filtered.map { |num| num.to_s }
  end

  def reject_all_digits_except_exact_match(guess)
    @potential_codes.reject! do |code|
      has_any_digits = code.chars.any? do |digit|
        guess[:guess].include?(digit)
      end
      is_same = code == guess[:guess]
      has_any_digits && !is_same
    end
  end

  def next_potential_code(prev_guess)
    @guess_index = @potential_codes.find_index(prev_guess[:guess])
    @potential_codes.delete_at(@guess_index)
    puts "Codes: #{@potential_codes.length}"
    @guess_index = 0 if @guess_index >= @potential_codes.length
    @potential_codes[@guess_index]
  end
end
