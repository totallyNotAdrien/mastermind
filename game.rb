class Game
  def initialize()
    @history = []
    @attempt = 1
    @max_attempts = 12
  end

  def play
    play_game = setup

    if play_game
      how_to_play if @codebreaker.human
      puts "Crack the code in #{@max_attempts} attempts!"

      loop do
        puts history_string
        breaker_guess

        if @curr_guess.downcase == "cheat"
          puts "The Code: " + @code
          redo
        elsif @curr_guess.downcase == "q"
          puts "Thank you so much for playing my game!"
          @curr_feedback = ""
          break
        else
          feedback
        end

        @attempt += 1
        @history << { guess: @curr_guess, feedback: @curr_feedback }
        break if @curr_feedback == Codemaker::CORRECT * 4 ||
                 @attempt > @max_attempts
      end

      game_end
    end
  end

  private

  def history_string
    output = ""
    @history.each do |element|
      output << "#{element[:guess].chars.join(" ")}: #{element[:feedback]}\n\n"
    end
    output
  end

  def breaker_guess
    @curr_guess = @codebreaker.guess(@attempt, @history)
  end

  def feedback
    @curr_feedback = Codemaker::feedback(@curr_guess, @code)
  end

  def setup
    print "Welcome to Mastermind: a game where you can\n" +
          "try to crack a 4-digit code of the computer's\n" +
          "choosing, or vice versa\n\n"
    print "Select one of the following options:\n" +
            "\t[1] Crack the computer's code\n" +
            "\t[2] Have the computer crack your code\n" +
            "\t[3] Watch the computer crack its own code\n" +
            "\t[ANY] Quit\n\n"
    print "Selection: "
    input = gets.chomp.strip
    case input
    when "1"
      @codemaker = Codemaker.new
      @codebreaker = Codebreaker.new(true)
    when "2"
      @codemaker = Codemaker.new(true)
      @codebreaker = Codebreaker.new
    when "3"
      @codemaker = Codemaker.new
      @codebreaker = Codebreaker.new
    else
      return false
    end
    @code = @codemaker.create_code
    true
  end

  def game_end
    congrat_str = (@codebreaker.human ? "You have" : "Computer has")
    codebreaker_str = (@codebreaker.human ? "You" : "Computer")
    if @curr_feedback == Codemaker::CORRECT * 4
      puts history_string
      puts "Conglaturation !!!\n#{congrat_str} cracked a great code."
    elsif @attempt > @max_attempts
      puts history_string
      puts codebreaker_str + " failed to crack the code."
    end
  end

  def how_to_play
    puts
    puts "How To Play"
    puts
    puts "[1]The computer will choose a 4-digit code using the digits 1-6."
    puts "You must crack the code in #{@max_attempts} attempts."
    puts
    puts "[2]After making a guess, you will be shown your guess and feedback"
    puts "about the accuracy of your guess using the letters 'C' and 'I'."
    puts
    puts "[3]The number of 'C's in the feedback is the number of correct"
    puts "digits that are correctly placed in your guess."
    puts
    puts "[4]The number of 'I's is the number of correct digits that are"
    puts "incorrectly placed in your guess."
    puts
    puts "[5]The order of the letters in the feedback will always have any 'C's"
    puts "first, so there is no correlation between their order and your guess."
    puts
    puts "[6]Empty feedback means that none of the digits in your guess are correct."
    puts "Feedback shorter than 4 characters means that there is at least one"
    puts "digit in your guess that is not in the computer's code"
    puts
    puts "[7]Ex: a guess of '2546' and feedback of 'CCI' means that 2 digits"
    puts "are exactly correct and 1 is incorrectly placed, NOT necessarily that"
    puts "'2' and '5' are exactly correct and '4' is incorrectly placed"
    puts
    puts
  end

  attr_reader :codemaker
end
