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
    m = self.get_next_move @round.get_moves_as_hash(false), @round.get_moves_as_hash(true)
    set m[:x],m[:y]
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
  # the moves are arrays of all taken moves as hashes since now
  def get_next_move ki_moves,player_moves

    logger = ActiveRecord::Base.logger
    logger.debug '##################'
    logger.debug '## Entering get_next_moves'

    # first, let's create an array which holds all possible next moves
    ki_moves_options = self.get_all_move_options ki_moves+player_moves

    # now select all those moves, that would lead to a direct victory
    ki_moves_winning_options = ki_moves_options.select {|m| @round.has_winning_combination ki_moves+[m]}
    return ki_moves_winning_options[0] if ki_moves_winning_options.count > 0

    # it seems, there wheren't any direct victories.
    # so, let's check, if the player would win with one of those moves above
    ki_moves_options.each do |m|
      return m if @round.has_winning_combination player_moves+[m]
    end

    # the next move brings nothing, move random
    return ki_moves_options[0]

    logger.debug '##################'
  end

  # returns an array of hashes, containing all possible next moves
  def get_all_move_options moves
    logger = ActiveRecord::Base.logger

    move_options = []
    3.times do |x|
      3.times do |y|
        if moves.select{|m| m[:x]==x and m[:y]==y}.count ==1
          logger.debug '   x: '+x.to_s+' | y: '+y.to_s+' -> exist'
        else
          logger.debug '   x: '+x.to_s+' | y: '+y.to_s+' -> possible'
          move_options.push Hash[:x=>x,:y=>y]
        end
      end
    end
    move_options
  end

end
