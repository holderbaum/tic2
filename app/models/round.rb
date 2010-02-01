class Round < ActiveRecord::Base

  has_many :moves

  # some const values, especially for the status field

  RUNNING = 0
  WON     = 1
  LOST    = 2
  DRAWN   = 3


  # just a wrapper, will be replaced later, when 2nd version  of compute_state
  # works
  def compute_state
    self.compute_state_2
  end

  # status represents the state of the actual round in a way, thats simpler to
  # handle than all those biiiig SQL-Statements.
  # It returns WON, LOST, DRAWN or RUNNING
  #
  # (TODO: This method comes whith a great redundanca, which should be reduced by a
  # helper-method)
  def compute_state_1 # {{{
    # return :player_win if there are 3 moves with same x/y value
    3.times { |x| 
      if  self.moves.find(:all,:conditions => {:x => x,:by_player => true}).count == 3 or
          self.moves.find(:all,:conditions => {:y => x,:by_player => true}).count == 3
          return WON
      end
    }

    #returns :player_win if a diagonal line is found
    if self.moves.find(:first,:conditions => {:x => 1,:y => 1, :by_player => true})
      # the player has a cross in the middle of the field
      if self.moves.find(:first,:conditions => {:x => 0,:y => 0, :by_player => true})
        # the player has a cross in the bott. left corner
        
        return WON if self.moves.find(:first,:conditions => {:x => 2,:y => 2, :by_player => true})
        # the player makes a line ;)


      elsif self.moves.find(:first,:conditions => {:x => 2,:y => 0, :by_player => true})
        # the player has a cross in the bott. right corner 

        return WON if self.moves.find(:first,:conditions => {:x => 0,:y => 2, :by_player => true})
        # the player makes a line ;)

      end
    end

    # return :ki_win if there are 3 moves with same x/y value
    3.times { |x| 
      if  self.moves.find(:all,:conditions => {:x => x,:by_player => false}).count == 3 or
          self.moves.find(:all,:conditions => {:y => x,:by_player => false}).count == 3
          return LOST
      end
    }

    #returns :ki_win if a diagonal line is found
    if self.moves.find(:first,:conditions => {:x => 1,:y => 1, :by_player => false})
      # the ki has a cross in the middle of the field
      if self.moves.find(:first,:conditions => {:x => 0,:y => 0, :by_player => false})
        # the ki has a cross in the bott. left corner
        
        return LOST if self.moves.find(:first,:conditions => {:x => 2,:y => 2, :by_player => false})
        # the ki makes a line ;)


      elsif self.moves.find(:first,:conditions => {:x => 2,:y => 0, :by_player => false})
        # the ki has a cross in the bott. right corner 

        return LOST if self.moves.find(:first,:conditions => {:x => 0,:y => 2, :by_player => false})
        # the ki makes a line ;)

      end
    end

    # return a :field_full if there are 9 moves
    return DRAWN if self.moves.find(:all).count == 3*3

    RUNNING
  end # }}}


  # moves is an array of hashes, representating the ccordinates of moves:
  #  example: [ [:x,:y],.. ]
  def has_winning_combination moves

    # return true if there are 3 moves with same x/y value
    3.times do |x|
      if moves.select{|m| m[:x] == x}.count == 3 or moves.select{|m| m[:y] == x}.count == 3
        return true
      end
    end

    #returns :player_win if a diagonal line is found:
    if moves.select{|m| m[:x]== 1 and m[:y]==1}.count==1
      # the player has a cross in the middle of the field
      if moves.select{|m| m[:x]== 0 and m[:y]==0}.count==1
        # the player has a cross in the bott. left corner
       
        return true if moves.select{|m| m[:x]==2 and m[:y]==2}.count==1
        # the player makes a line ;)

      elsif moves.select{|m| m[:x]==2 and m[:y]==0}.count==1
        # the player has a cross in the bott. right corner 

        return true if moves.select{|m| m[:x]==0 and m[:y]==2}.count==1
        # the player makes a line ;)
      end
    end
    
    return false
  end

  def get_moves_as_hash by_player
    moves = []
    self.moves.find(:all,:conditions=>{:by_player=>by_player}).each do |m|
      moves.push Hash[:x=>m.x,:y=>m.y]
    end
    moves
  end

  # compute_state v2
  def compute_state_2 # {{{
    
    player_moves = []
    ki_moves = []

    player_moves = self.get_moves_as_hash true
    ki_moves = self.get_moves_as_hash false
    
    return WON if  has_winning_combination player_moves
    return LOST if has_winning_combination ki_moves
    
    return DRAWN if player_moves.count + ki_moves.count == 3*3

    RUNNING
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
