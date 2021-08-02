class Game
  # track all guesses and feedback
  # get guess
  # get guess feedback

  #
  def initialize(codemaker, codebreaker)
    @codemaker = codemaker
    @codebreaker = codebreaker
    @feedback = []
  end

  def play
    @code = @codemaker.create_code
    puts @code.join("")
  end

  def breaker_guess
    @curr_guess = @codebreaker.guess()
  end

  def feedback
    @curr_feedback = @codemaker.feedback()
  end

  private
  attr_reader :codemaker
end
