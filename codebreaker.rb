require_relative "utils.rb"

class Codebreaker
  include Utils

  SAME_CHAR = "S"
  DIFF_CHAR = "D"

  attr_reader :human

  def initialize(human = false)
    @human = human
    @potential_codes = all_codes
  end

  def guess(attempt, guess_history)
    if human
      human_guess(attempt)
    else
      guess = computer_guess(guess_history)
      sleep(1)
      puts "Attempt ##{attempt}: #{guess}"
      guess
    end
  end

  private

  def human_guess(attempt)
    print "Attempt ##{attempt}: " +
            "Enter four digits (1-6) to guess or 'q' to quit: "

    guess = gets.chomp.strip
    until (guess.length == 4 && all_digits?(guess) &&
           all_chars_between?(guess, "1", "6")) || guess.downcase == "q" ||
          guess.downcase == "cheat"
      puts "Make sure your guess consists of 4 digits between 1 and 6"
      guess = gets.chomp.strip
    end
    
    guess
  end

  #"history" entry format:
  #{ guess: "1234", feedback: "CCII" }
  def computer_guess(history)
    prev_history_entry = history.last
    if prev_history_entry
      prev_guess = prev_history_entry[:guess]
      prev_feedback = prev_history_entry[:feedback]

      if prev_feedback.empty?
        remove_all_digits_except_exact_match(prev_guess)
        return next_potential_code(prev_guess)
      else
        remove_codes_except_exact_match_knuth(prev_guess, prev_feedback)
        return next_potential_code(prev_guess)
      end
    else
      @guess_index = rand(@potential_codes.length)
      @potential_codes[@guess_index]
    end
  end

  def all_codes
    codes = (1111..6666).to_a
    codes.map! { |num| num.to_s }
    codes.select do |code|
      all_chars_between?(code, "1", "6")
    end
  end

  def remove_codes_except_exact_match_knuth(guess, feedback)
    @potential_codes.reject! do |code|
      feedback != Codemaker::feedback(code, guess) &&
        code != guess
    end
  end

  def remove_all_digits_except_exact_match(guess)
    @potential_codes.reject! do |code|
      has_any_digits = code.chars.any? do |digit|
        guess.include?(digit)
      end
      is_same = code == guess
      has_any_digits && !is_same
    end
  end

  def next_potential_code(guess)
    adjust_guess_index(guess)
    @potential_codes[@guess_index]
  end

  def adjust_guess_index(guess)
    @guess_index = @potential_codes.find_index(guess)
    @potential_codes.delete_at(@guess_index)
    @guess_index = 0 if @guess_index >= @potential_codes.length
  end
end
