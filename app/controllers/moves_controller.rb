class MovesController < ApplicationController

  before_filter :check_round

  # GET /moves/new
  # GET /moves/new.xml
  def new # {{{
    @move = Move.new

  end # }}}

  # This action only creates the right move!
  # Since moves a created out of the show-round-action, this one should redirect
  # back to rounds.
  #
  # POST /moves
  # POST /moves.xml
  def create # {{{
    round = Round.find(@round_id)
    if (status = round.compute_state) == Round::RUNNING

      @move = Move.new(params[:move])

      @move.round_id = @round_id

      if @move.save
        flash[:notice] = 'Move was successfully created.'

        if (status = round.compute_state) == Round::RUNNING
          ki = KI.new @round_id
          ki.move
        end

      else
        flash[:error] = 'Move couldnt be created.'
      end
    end
    # the flash notices are only for debugging purposes.
    # primary is this construct for setting the right round.state, depending
    # on the current status
    round.state = round.compute_state
#    unless (status = round.compute_state) == Round::RUNNING
#      round.state 
#      if status == Round::WON
#        flash[:notice] = 'You win!'
#        round.state = Round::WON
#      elsif status == Round::LOST
#        flash[:notice] = 'You lose'
#        round.state = Round::LOST
#      elsif status == Round::DRAWN
#        flash[:notice] = 'Draw!'
#        round.state = Round::DRAWN
#      end

      round.save

    redirect_to round_url @round_id
  end # }}}


  # this filter checks for the occurence of round_id in the session hash.
  # if it dont exist, there is obvious no running round and the user should be
  # redirected immediately back to the landing page
  def check_round # {{{
    redirect_to rounds_url unless session[:round_id]
    @round_id = session[:round_id]
  end # }}}

end
