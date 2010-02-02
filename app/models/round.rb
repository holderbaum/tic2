class Round < ActiveRecord::Base

  has_many :moves

  # some const values, especially for the status field

  RUNNING = 0
  WON     = 1
  LOST    = 2
  DRAWN   = 3


  # compute_state computes the state of the actual round in a
  # It returns WON, LOST, DRAWN or RUNNING
  def compute_state # {{{

    player_moves = []
    ki_moves = []

    player_moves = self.get_moves_as_hash true
    ki_moves = self.get_moves_as_hash false

    return WON if  has_winning_combination player_moves
    return LOST if has_winning_combination ki_moves

    return DRAWN if player_moves.count + ki_moves.count == 3*3

    RUNNING
  end # }}}

  # the param moves is an array of hashes, representating the ccordinates of moves:
  #  example: [ {:x,:y},.. ]
  # this method computes if the given array contains move-constellations which
  # leads to a victory
  def has_winning_combination moves # {{{

    # return true if there are 3 moves with same x/y value
    3.times do |x|
      if moves.select{|m| m[:x] == x}.count == 3 or moves.select{|m| m[:y] == x}.count == 3
        return true
      end
    end

    #returns :player_win if a diagonal line is found:
    if moves.select{|m| m[:x]== 1 and m[:y]==1}.count==1
      # the player has a cross in the middle of the field
      if moves.select{|m| m[:x]==0 and m[:y]==0}.count==1
        # the player has a cross in the bott. left corner

        return true if moves.select{|m| m[:x]==2 and m[:y]==2}.count==1
        # the player makes a line ;)

      end
      if moves.select{|m| m[:x]==2 and m[:y]==0}.count==1
        # the player has a cross in the bott. right corner 

        return true if moves.select{|m| m[:x]==0 and m[:y]==2}.count==1
        # the player makes a line ;)
      end
    end

    return false
  end # }}}

  # this creates an array, containing hashes which represents moves. This format
  # is used by the KI and has_winning_combination, because it gives great
  # possibilities to cache the moves out of the DB (saves DB IO)
  def get_moves_as_hash by_player # {{{
    moves = []
    self.moves.find(:all,:conditions=>{:by_player=>by_player}).each do |m|
      moves.push Hash[:x=>m.x,:y=>m.y]
    end
    moves
  end # }}}

  # creates an array which represents the actual gaming-field
  # this is used by the view to build a nice html-table
  def field # {{{
    iy = 0
    field = Array.new(3) { |y|
      ix=0
      y = Array.new(3) { |x|
        if move=self.moves.find(:first,:conditions => { :x => ix,:y => iy })
          if move.by_player
            x = 1
          else
            x = 2
          end
        else
          x = 0
        end
        ix+=1
        x
      }
      iy+=1
      y
    }
  end # }}}



end
