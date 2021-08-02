class Codebreaker
  attr_reader :human

  include Utils

  def initialize(human = false)
    @human = human
  end

  def guess()
    if human
      human_guess()
    end
  end

  private 

  def human_guess()
    puts "Enter four digits (1-6) to guess or 'q' to quit"
    guess = gets.chomp.strip
    until (guess.length == 4 && all_digits?(guess) && guess.chars) || guess == 'q'
      puts "Make sure your guess consists of 4 digits between 1 and 6"
      guess = gets.chomp.strip
    end
  end
end