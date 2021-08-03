class Game
  # track all guesses and feedback
  # get guess
  # get guess feedback

  #
  def initialize(codemaker, codebreaker)
    @codemaker = codemaker
    @codebreaker = codebreaker
    @guess_history = []
  end

  def play
    @code = @codemaker.create_code
    loop do
      breaker_guess
      if @curr_guess == "cheat"
        puts "These digits: " + @code.join("")
      elsif @curr_guess == "q"
        puts "Thank you so much for playing my game!"
        @curr_feedback = ""
        break
      else
        feedback
        unless @curr_feedback == Codemaker::CORRECT * 4
          puts "\n\n#{@curr_guess}: #{@curr_feedback}\n\n"
        end
      end

      @guess_history << { guess: @curr_guess, feedback: @curr_feedback }
      break if @curr_feedback == Codemaker::CORRECT * 4
    end
    
    unless @curr_feedback.empty?
      puts "Conglaturation !!!\nYou have cracked a great code."
    end
  end

  def breaker_guess
    @curr_guess = @codebreaker.guess()
  end

  def feedback
    @curr_feedback = @codemaker.feedback(@curr_guess, @code)
  end

  private

  attr_reader :codemaker
end
