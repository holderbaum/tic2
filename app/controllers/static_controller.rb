class StaticController < ApplicationController

  # this is the landing-page. It displays the input-field for username or
  # redirects to the game itself
  def index
    unless session[:round_id]
      @round = Round.new
    else
      redirect_to game_path
    end
  end

  # the first n rounds are listed, ordered by the duration and the amount of
  # moves per round
  def highscore
    @rounds = Round.find(:all,:conditions=>{:state => Round::WON})

    @hscore = []
    @rounds.each do |x|
      var = {}
      var[:duration] = (x.updated_at - x.created_at).to_i
      var[:player] = x.player
      var[:moves] = Move.find(:all,:conditions=>{:round_id=> x.id}).count
      @hscore << var
    end
    @hscore = (@hscore.sort_by {|x| [x[:moves],x[:duration]]})[0,10]
    

  end


end
