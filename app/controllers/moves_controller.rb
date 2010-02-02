class MovesController < ApplicationController

  before_filter :check_round

  # GET /moves/new
  # GET /moves/new.xml
  def new # {{{
    @move = Move.new
  end # }}}

  # This action creates the  move for the given coords and calls the move-method
  # of the KI-Model.
  # Since moves are created out of the show-round-action, this one should redirect
  # back to show-rounds.
  #
  # POST /moves
  # POST /moves.xml
  def create # {{{
    round = Round.find(@round_id)
    if round.compute_state == Round::RUNNING

      @move = Move.new(params[:move])

      @move.round_id = @round_id

      if @move.save
        # the state could have changed, because of the move added above by player
        if round.compute_state == Round::RUNNING
          ki = KI.new @round_id
          ki.move
        end
      end

    end # this stuff above should only be done, if the round is still running
    
    # update the state of the round whith the new computed status
    round.state = round.compute_state
    
    round.save

    redirect_to round_url @round_id
  end # }}}


  # this filter checks for the occurence of round_id in the session hash.
  # if it don't exist, there is obvious no running round and the user should be
  # redirected immediately back to the landing page
  def check_round # {{{
    redirect_to rounds_url unless session[:round_id]
    @round_id = session[:round_id]
  end # }}}

end
