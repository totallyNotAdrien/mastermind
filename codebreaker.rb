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
    prev_guess = history.last
    penultimate_guess =
      (history.length >= 2) ? history[history.length - 2] : nil

    if prev_guess && penultimate_guess
      return next_potential_code(prev_guess[:guess])
    elsif prev_guess
      p prev_guess
      if prev_guess[:feedback].empty?
        reject_all_digits_except_exact_match(prev_guess)
        return next_potential_code(prev_guess[:guess])
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

  def remove_codes_with_digit_except_match(digit, guess_str)
    @potential_codes.reject! do |code|
      code.include?(digit) && code != guess_str
    end
  end

  def remove_codes_with_digit(digit)
    @potential_codes.reject! do |code|
      code.include?(digit)
    end
  end

  def remove_codes_with_any_digit_in_same_place(guess_str)
    @potential_codes.reject! do |code|
      remove = false
      guess_str.chars.each_index do |index|
        remove = true if code[index] == guess_str[index]
      end
      remove
    end
  end

  def remove_codes_with_any_digit_in_same_place_except_match(guess_str)
    @potential_codes.reject! do |code|
      remove = false
      guess_str.chars.each_index do |index|
        remove = true if code[index] == guess_str[index] && code != guess_str
      end
      remove
    end
    adjust_guess_index(guess_str)
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

  def next_potential_code(guess_str)
    adjust_guess_index(guess_str)
    @potential_codes[@guess_index]
  end

  def adjust_guess_index(guess_str)
    @guess_index = @potential_codes.find_index(guess_str)
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
    diff.chars.each_index{|i| indices << i if diff[i] == DIFF_CHAR}
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
    patterns.any?{|pat| same_length_match?(str_to_match, pat)}
  end

  def same_length_match_no_pattern?(str_to_match, patterns, wildcard = "*")
    !same_length_match_any_pattern?(str_to_match,patterns, wildcard)
  end

  def patterns_to_match(guess_str, num_correct, num_incorrect, wildcard = "*")
    #only correct
    patterns = []
    if num_incorrect == 0
      if num_correct == 1
        #one correct
        4.times do |i|
          pat = wildcard * 4
          pat[i] = guess_str[i]
          patterns << pat
        end
      elsif num_correct == 2
        #two correct
        for i in 0...(guess_str.length - 1)
          for j in (i + 1)...guess_str.length
            pat = wildcard * 4
            pat[i] = guess_str[i]
            pat[j] = guess_str[j]
            patterns << pat
          end
        end
      elsif num_correct == 3
        4.times do |i|
          pat = guess_str.clone
          pat[i] = wildcard
          patterns << pat
        end
      end
    elsif num_correct == 4
      patterns << guess_str
    end
    patterns
  end
end
