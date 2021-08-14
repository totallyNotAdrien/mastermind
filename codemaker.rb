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
      code_counts = occurrences(code)
      guess_counts = occurrences(guess)

      num_potentially_correct = 
        num_potentially_correct_digits(guess_counts, code_counts)

      num_correct = 0
      guess.chars.each_index { |i| num_correct += 1 if guess[i] == code[i] }
      num_incorrectly_placed = num_potentially_correct - num_correct

      (CORRECT * num_correct) + (INCORRECT_PLACEMENT * num_incorrectly_placed)
    end
  end

  private

  def self.occurrences(str)
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

  #guess_counts and code_counts are hashes with entries for
  #each digit in the code (ex: "2334" = {"2"=>1, "3"=>2, "4"=>1})
  def self.num_potentially_correct_digits(guess_counts, code_counts)
    num_potentially_correct = 0
    code_counts.each_key do |digit|
      if guess_counts[digit] > 0
        if guess_counts[digit] < code_counts[digit]
          num_potentially_correct += guess_counts[digit]
        else
          num_potentially_correct += code_counts[digit]
        end
      end
    end
    num_potentially_correct
  end
end
