require_relative "utils.rb"
class Codemaker
  include Utils

  attr_reader :human

  def initialize(human = false)
    @human = human
  end

  def create_code
    if human
      human_code
    else
      computer_code
    end
  end

  def self.feedback(guess, code)
    if guess == code
      CORRECT * 4
    else
      code_tally = tally_occurrences(code)
      guess_tally = tally_occurrences(guess)

      num_potentially_correct = 0
      code_tally.each_key do |digit|
        if guess_tally[digit] > 0
          if guess_tally[digit] < code_tally[digit]
            num_potentially_correct += guess_tally[digit]
          else
            num_potentially_correct += code_tally[digit]
          end
        end
      end

      num_correct = 0
      guess.chars.each_index { |i| num_correct += 1 if guess[i] == code[i] }
      num_incorrectly_placed = num_potentially_correct - num_correct

      (CORRECT * num_correct) + (INCORRECT_PLACEMENT * num_incorrectly_placed)
    end
  end

  private

  def self.tally_occurrences(str)
    arr = str.chars
    tally = Hash.new(0)
    arr.each { |item| tally[item] += 1 }
    tally
  end

  def human_code
    print "Enter four digits (1-6) for the computer to guess (ex: '1632'): "
    input = gets.chomp.strip
    until (input.length == 4 && all_digits?(input) &&
           all_chars_between?(input, "1", "6"))
      puts "Make sure your number consists of 4 digits between 1 and 6"
      print "Number: "
      input = gets.chomp.strip
    end
    input
  end

  def computer_code
    code = []
    4.times { code << rand(1..6).to_s }
    code.join("")
  end
end
