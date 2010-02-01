class KI

  def initialize round_id # {{{
    @round = Round.find(round_id)
    # let's chache the moves, this will save many DBIO so far
    @ki_moves = @round.moves.find(:all,:conditions=>{:by_player=>false})
    @player_moves = @round.moves.find(:all,:conditions=>{:by_player=>true}) 
  end # }}}

  # this modualarises the code for setting a field, since this is an often
  # needed function
  def set x,y # {{{
    move = Move.new
    move.x = x
    move.y = y
    move.by_player = false
    move.round_id = @round.id
    move.save
  end # }}}

  # this method will fulfill the move with all the needed logic behind.
  # for now, it calls self.random and returns back
  # (A KI will be implemented soon)
  def move # {{{
    self.get_next_moves nil
    self.random -1,-1
    return
    # first check, if I did not make any move
    if @ki_moves.count == 0
      # now check, if the player has already made a move
      if @player_moves.count == 1
        # player has moved. I need to make sure, he don't build three X's around
        # a corner
        if @player_moves[0].x == 0 and @player_moves[0].y == 0
          # the player is in the middle of the field
          self.random -1,-1
        elsif @player_moves[0].x != 1
        elsif @player_moves[0].y != 1
        end
      else
        # I'm at first, lets make a random move
        self.random -1,-1
      end

    end
    
  end # }}}

  # random makes a random move. but it has a little speciallity. It only
  # randomize those coords, which are set to -1. others remain by their given
  # values
  def random setx,sety # {{{
    field = @round.field
    x = setx unless setx == -1
    y = sety unless sety == -1
    unless @round.compute_state == Round::DRAWN
      begin    
        x = rand(3) if setx == -1
        y = rand(3) if sety == -1
      end until field[y][x] == 0
    end

    self.set x,y
  end # }}}

  # the ki should compute the next moves.
  # this method can help
  #
  # moves is an array of all taken moves since now
  def get_next_moves moves

    

    logger = ActiveRecord::Base.logger
    logger.debug '##################'
    logger.debug '## Entering get_next_moves'
    3.times do |x|
      3.times do |y|
        logger.debug '   x: '+x.to_s+' | y: '+y.to_s

      end
    end

    logger.debug '##################'
  end
end
