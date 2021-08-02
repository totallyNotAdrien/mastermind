require './utils.rb'
class Codemaker
  attr_reader :human

  include Utils

  def initialize(human = false)
    @human = human
  end
end