class Codemaker
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

  private

  def human_code
  end

  def computer_code
    code = []
    4.times { code << rand(1..6).to_s }
    code
  end
end
