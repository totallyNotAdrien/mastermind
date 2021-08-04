class Codemaker
  attr_reader :human

  CORRECT = "C"
  INCORRECT_PLACEMENT = "I"

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

  def feedback(guess, code)
    if guess == code
      CORRECT * 4
    else
      code_tally = tally_occurrences(code)
      guess_tally = tally_occurrences(guess)
      # puts "Code Tally: #{code_tally}"
      # puts "Guess Tally: #{guess_tally}"

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
      #puts "Potentially correct: #{num_potentially_correct}"

      num_correct = 0
      guess.chars.each_index {|i| num_correct += 1 if guess[i] == code[i]}
      remaining_potentially_correct = num_potentially_correct - num_correct

      (CORRECT * num_correct) + (INCORRECT_PLACEMENT * remaining_potentially_correct)

      #tally up instances of each digit in code
      #tally up instances of each digit in guess
      #for each digit in guess that is in code
        #if num in guess < num in code
          #num potentially correct + num in guess
        #else
          #num potentially correct + num in code
      #for each digit in guess that is correct
        #num potentially correct - 1
        #num correct + 1
    end
  end

  private

  def tally_occurrences(str)
    arr = str.chars
    tally = Hash.new(0)
    arr.each {|item| tally[item] += 1}
    tally
  end

  def human_code
  end

  def computer_code
    code = []
    4.times { code << rand(1..6).to_s }
    code.join("")
  end
end
