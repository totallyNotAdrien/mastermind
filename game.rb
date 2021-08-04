class Game
  # track all guesses and feedback
  # get guess
  # get guess feedback

  #
  def initialize(codemaker, codebreaker)
    @codemaker = codemaker
    @codebreaker = codebreaker
    @history = []
    @attempt = 1
  end

  def play
    puts "Crack the code in 12 attempts!"
    @code = @codemaker.create_code
    loop do
      puts guess_history
      breaker_guess

      if @curr_guess == "cheat"
        puts "These digits: " + @code
        redo
      elsif @curr_guess == "q"
        puts "Thank you so much for playing my game!"
        @curr_feedback = ""
        break
      else
        feedback
      end

      @attempt += 1
      @history << { guess: @curr_guess, feedback: @curr_feedback }
      break if @curr_feedback == Codemaker::CORRECT * 4 ||
        @attempt > 12
    end
    
    if @curr_feedback == Codemaker::CORRECT * 4
      puts guess_history
      puts "Conglaturation !!!\nYou have cracked a great code."
    elsif @attempt > 12
      puts "You failed to crack the code."
    end
  end

  private

  def guess_history
    output = ""
    @history.each do |element| 
      output << "#{element[:guess].chars.join(" ")}: #{element[:feedback]}\n\n"
    end
    output
  end

  def breaker_guess
    @curr_guess = @codebreaker.guess(@attempt)
  end

  def feedback
    @curr_feedback = @codemaker.feedback(@curr_guess, @code)
  end

  attr_reader :codemaker
end
