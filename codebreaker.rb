require "pry-byebug"
require_relative "utils.rb"

class Codebreaker
  attr_reader :human

  CORRECT = "C"
  INCORRECT_PLACEMENT = "I"

  SAME_CHAR = "S"
  DIFF_CHAR = "D"

  include Utils

  def initialize(human = false)
    @human = human
    @potential_codes = all_codes
    @oi_count = 0
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
    prev_history_entry = history.last
    if prev_history_entry
      p prev_history_entry

      prev_guess = prev_history_entry[:guess]
      prev_feed = prev_history_entry[:feedback]
      if prev_history_entry[:feedback].empty?
        remove_all_digits_except_exact_match(prev_guess)
        return next_potential_code(prev_guess)
      else
        knuth_remove_codes_except_exact_match(prev_guess, prev_feed)
        return next_potential_code(prev_guess)
      end
      #binding.pry
    else
      @guess_index = rand(@potential_codes.length)
      @potential_codes[@guess_index]
      #"1122"
    end
  end

  def all_codes
    codes = (1111..6666).to_a
    codes.map! { |num| num.to_s }
    codes.select do |code|
      all_chars_between?(code, "1", "6")
    end
  end

  def knuth_remove_codes_except_exact_match(guess, feedback)
    @potential_codes.reject! do |code|
      feedback != Codemaker::feedback(code, guess) &&
        code != guess
    end
  end

  def remove_codes_with_digit_except_match(digit, guess)
    @potential_codes.reject! do |code|
      code.include?(digit) && code != guess
    end
  end

  def remove_codes_with_digit(digit)
    @potential_codes.reject! do |code|
      code.include?(digit)
    end
  end

  def remove_codes_with_any_digit_in_same_place(guess)
    @potential_codes.reject! do |code|
      remove = false
      guess.chars.each_index do |index|
        remove = true if code[index] == guess[index]
      end
      remove
    end
  end

  def remove_codes_with_any_digit_in_same_place_except_match(guess)
    @potential_codes.reject! do |code|
      remove = false
      guess.chars.each_index do |index|
        remove = true if code[index] == guess[index] && code != guess
      end
      remove
    end
    adjust_guess_index(guess)
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
    puts "Codes: #{@potential_codes.length}"
    @guess_index = 0 if @guess_index >= @potential_codes.length
  end

  def string_differences(str1, str2)
    diff = ""
    short = str1.length <= str2.length ? str1 : str2
    long = short == str1 ? str2 : str1
    long.chars.each_index do |i|
      if i < short.length
        comparison = long[i] == short[i] ? SAME_CHAR : DIFF_CHAR
        diff << comparison
      else
        diff << DIFF_CHAR
      end
    end
    diff
  end

  def string_diff_indices(str1, str2)
    diff = string_differences(str1, str2)
    indices = []
    diff.chars.each_index { |i| indices << i if diff[i] == DIFF_CHAR }
    indices
  end

  def same_length_match?(str_to_match, pattern, wildcard = "*")
    return false if str_to_match.length != pattern.length
    str = str_to_match.chars
    pat = pattern.chars
    pat.each_index do |i|
      return false if str[i] != pat[i] && pat[i] != wildcard
    end
    return true
  end

  def same_length_match_any_pattern?(str_to_match, patterns, wildcard = "*")
    patterns.any? { |pat| same_length_match?(str_to_match, pat) }
  end

  def same_length_match_no_pattern?(str_to_match, patterns, wildcard = "*")
    !same_length_match_any_pattern?(str_to_match, patterns, wildcard)
  end

  def patterns_to_match(guess, num_correct, num_incorrect, wildcard = "*")
    #only correct
    patterns = []
    if num_incorrect == 0
      if num_correct == 1
        #one correct
        4.times do |i|
          pat = wildcard * 4
          pat[i] = guess[i]
          patterns << pat
        end
      elsif num_correct == 2
        #two correct
        for i in 0...(guess.length - 1)
          for j in (i + 1)...guess.length
            pat = wildcard * 4
            pat[i] = guess[i]
            pat[j] = guess[j]
            patterns << pat
          end
        end
      elsif num_correct == 3
        4.times do |i|
          pat = guess.clone
          pat[i] = wildcard
          patterns << pat
        end
      end
    elsif num_correct == 4
      patterns << guess
    end
    patterns
  end
end
