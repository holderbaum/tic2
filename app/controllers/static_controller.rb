class StaticController < ApplicationController

  # this is the landing-page. It displays the input-field for username or
  # redirects to the game itself
  def index
    unless session[:round_id]
      @round = Round.new
    else
      # when :round_id in the session-hash is already set, we can recirect to
      # the game-interface
      redirect_to game_path
    end
  end

  # the first 10 rounds are listed, ordered by the duration and the amount of
  # moves per round
  def highscore
    # perhaps, this could be done much more elegant with some SQL (JOINs or
    # things like that)
    @rounds = Round.find(:all,:conditions=>{:state => Round::WON})

    @hscore = []
    @rounds.each do |x|
      var = {}
      var[:duration] = (x.updated_at - x.created_at).to_i
      var[:player] = x.player
      var[:moves] = Move.find(:all,:conditions=>{:round_id=> x.id,:by_player=>true}).count
      @hscore << var
    end
    @hscore = (@hscore.sort_by {|x| [x[:moves],x[:duration]]})[0,10]
    

  end


end
