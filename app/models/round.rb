class Round < ActiveRecord::Base

  has_many :moves

  # some const values, especially for the status field

  RUNNING = 0
  WON     = 1
  LOST    = 2
  DRAWN   = 3


  # status represents the state of the actual round in a way, thats simpler to
  # handle than all those biiiig SQL-Statements.
  # It returns :player_win, :ki_win, :field_full or :running
  #
  # (TODO: This method comes whith a great redundanca, which should be reduced by a
  # helper-method)
  def status # {{{
   
    # return :player_win if there are 3 moves with same x/y value
    3.times { |x| 
      if  self.moves.find(:all,:conditions => {:x => x,:by_player => true}).count == 3 or
          self.moves.find(:all,:conditions => {:y => x,:by_player => true}).count == 3
          return :player_win
      end
    }

    #returns :player_win if a diagonal line is found
    if self.moves.find(:first,:conditions => {:x => 1,:y => 1, :by_player => true})
      # the player has a cross in the middle of the field
      if self.moves.find(:first,:conditions => {:x => 0,:y => 0, :by_player => true})
        # the player has a cross in the bott. left corner
        
        return :player_win if self.moves.find(:first,:conditions => {:x => 2,:y => 2, :by_player => true})
        # the player makes a line ;)


      elsif self.moves.find(:first,:conditions => {:x => 2,:y => 0, :by_player => true})
        # the player has a cross in the bott. right corner 

        return :player_win if self.moves.find(:first,:conditions => {:x => 0,:y => 2, :by_player => true})
        # the player makes a line ;)

      end
    end

    # return :ki_win if there are 3 moves with same x/y value
    3.times { |x| 
      if  self.moves.find(:all,:conditions => {:x => x,:by_player => false}).count == 3 or
          self.moves.find(:all,:conditions => {:y => x,:by_player => false}).count == 3
          return :ki_win
      end
    }

    #returns :ki_win if a diagonal line is found
    if self.moves.find(:first,:conditions => {:x => 1,:y => 1, :by_player => false})
      # the ki has a cross in the middle of the field
      if self.moves.find(:first,:conditions => {:x => 0,:y => 0, :by_player => false})
        # the ki has a cross in the bott. left corner
        
        return :ki_win if self.moves.find(:first,:conditions => {:x => 2,:y => 2, :by_player => false})
        # the ki makes a line ;)


      elsif self.moves.find(:first,:conditions => {:x => 2,:y => 0, :by_player => false})
        # the ki has a cross in the bott. right corner 

        return :ki_win if self.moves.find(:first,:conditions => {:x => 0,:y => 2, :by_player => false})
        # the ki makes a line ;)

      end
    end

    # return a :field_full if there are 9 moves
    return :field_full if self.moves.find(:all).count == 3*3

    :running
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
