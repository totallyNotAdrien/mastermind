require_relative 'game.rb'
require_relative 'codemaker.rb'
require_relative 'codebreaker.rb'
require_relative 'utils.rb'


# until player quits
#   show instructions
#   ask if player will be maker, breaker, or neither, or quit
#   create new game
#   get code from maker
#   until game finished
#     get guess from breaker
#     show guess feedback
#   end
#   show winner
# end

game = Game.new.play