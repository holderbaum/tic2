class MovesController < ApplicationController

  before_filter :check_round

  ## TODO: Obsolete, will be removed soon
  # GET /moves
  # GET /moves.xml
  def index
    @moves = Move.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @moves }
    end
  end
  #######################################

  ## TODO: Obsolete, will be removed soon
  # GET /moves/1
  # GET /moves/1.xml
  def show
    @move = Move.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @move }
    end
  end
  #######################################

  # GET /moves/new
  # GET /moves/new.xml
  def new
    @move = Move.new

  end

  # This action only creates the right move!
  # Since moves a created out of the show-round-action, this one should redirect
  # back to rounds.
  #
  # POST /moves
  # POST /moves.xml
  def create
    round = Round.find(@round_id)
    if (status = round.status) == :running
      
      @move = Move.new(params[:move])

      @move.round_id = @round_id

      if @move.save
        flash[:notice] = 'Move was successfully created.'
        
        if (status = round.status) == :running
            ki = KI.new @round_id
#            ki.random
            ki.move
        end
      
      else
        flash[:error] = 'Move couldnt be created.'
      end
    end
      unless (status = round.status) == :running
        if status == :player_win
          flash[:notice] = 'You win!'
          round.state = Round::WON
        elsif status == :ki_win
          flash[:notice] = 'You lose'
          round.state = Round::LOST
        elsif status == :field_full
          flash[:notice] = 'Draw!'
          round.state = Round::DRAWN
        end
        round.save
      end
      
      redirect_to round_url @round_id
  end

  ## TODO: Obsolete, will be removed soon
  # PUT /moves/1
  # PUT /moves/1.xml
  def update
    @move = Move.find(params[:id])

    respond_to do |format|
      if @move.update_attributes(params[:move])
        flash[:notice] = 'Move was successfully updated.'
        format.html { redirect_to(@move) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @move.errors, :status => :unprocessable_entity }
      end
    end
  end
  #######################################

  ## TODO: Obsolete, will be removed soon
  # DELETE /moves/1
  # DELETE /moves/1.xml
  def destroy
    @move = Move.find(params[:id])
    @move.destroy

    respond_to do |format|
      format.html { redirect_to(moves_url) }
      format.xml  { head :ok }
    end
  end
  #######################################

  def check_round
    redirect_to rounds_url unless session[:round_id]
    @round_id = session[:round_id]
  end

end
