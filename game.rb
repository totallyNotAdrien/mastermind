class Game
  # track all guesses and feedback
  # get guess
  # get guess feedback

  #
  def initialize()
    @history = []
    @attempt = 1
  end

  def play
    play_game = setup

    if play_game
      puts "Crack the code in 12 attempts!"
      @code = @codemaker.create_code

      loop do
        puts history_string
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
      
      codebreaker_str = (@codebreaker.human ? "You" : "Computer")
      if @curr_feedback == Codemaker::CORRECT * 4
        puts history_string
        puts "Conglaturation !!!\nYou have cracked a great code."
      elsif @attempt > 12
        puts history_string
        puts codebreaker_str + " failed to crack the code."
      end
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
    true
  end

  attr_reader :codemaker
end
