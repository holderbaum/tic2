class KI

  def initialize round_id # {{{
    @round = Round.find(round_id)
  end # }}}

  # this method will fulfill the move with all the needed logic behind.
  # for now, it calls self.random and returns back
  # (A KI will be implemented soon)
  def move # {{{
    # find the best next move
    m = get_next_move @round.get_moves_as_hash(false), @round.get_moves_as_hash(true)
    # and create it instantly
    Move.new(:x=>m[:x],:y=>m[:y],:by_player=>false,:round_id=>@round.id).save
  end # }}}

  private

  # the ki should compute the next moves.
  # this method can help
  #
  # the moves are arrays of all taken moves as hashes since now
  def get_next_move ki_moves,player_moves # {{{
    # first, let's create an array which holds all possible next moves
    move_options = get_all_move_options ki_moves+player_moves

    # now select all those moves, that would lead to a direct victory
    move_winning_options = move_options.select {|m| @round.has_winning_combination ki_moves+[m]}
    return move_winning_options[0] if move_winning_options.count > 0

    # it seems, there wheren't any direct victories.
    # so, let's check, if the player would win with one of those moves above
    move_options.each do |m|
      return m if @round.has_winning_combination player_moves+[m]
    end

    # the next move brings nothing, move random
    return move_options[rand(move_options.count)]
  end # }}}

  # returns an array of hashes, containing all possible next moves
  def get_all_move_options moves # {{{
    # a nested loop, creating all those moves that don't exist, yet
    move_options = []
    3.times do |x|
      3.times do |y|
        move_options.push Hash[:x=>x,:y=>y] unless moves.select{|m| m[:x]==x and m[:y]==y}.count ==1
      end
    end
    move_options
  end # }}}

end
