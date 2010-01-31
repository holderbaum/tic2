class RoundsController < ApplicationController
  
  #before_filter :user_session

  # the index itself acts like a "proxy". When the client has
  # no round_id in its session, he will be redirected to the landing page.
  # Is round_id already set, the user'll be redirected to the correspondating url
  #
  # GET /rounds
  # GET /rounds.xml
  def index # {{{
    unless session[:round_id]
      redirect_to root_path
    else
      # here you can see the lower mentioned redundancy. calling an URL with a
      # param thats allready in a session?
      # TODO: fix it! for know, I dont know how to do it, but I soon will! :)
      redirect_to round_path session[:round_id]
    end
  end # }}}

  # This will be the place, where the gaming-field is displayed!
  # Every unset field should be clickable and shall redirect to the
  # move_creation url (you can see the implementation -- surprise,surprise -- in
  # the view)
  #
  # This is logical und follows the CRUD-principals
  # GET /rounds/1
  # GET /rounds/1.xml
  def show # {{{
    # crosschecks the given id to prevent abuse of the show-method
    # the RESTful urls create links, which sends the round_id.
    # TODO: KILLING this redundancy
    redirect_to rounds_url unless params[:id]!=session[:round_id]
    # this ^^

    @round = Round.find(params[:id])
    @move = Move.new
    @move.round_id = @round.id

    respond_to do |format|
      format.js do
        render :action => 'show', :layout => false
      end
      format.html do
        render :action => 'show'
      end
    end
    @round = Round.find(params[:id])
    @move = Move.new
    @move.round_id = @round.id
  end # }}}

  # GET /rounds/new
  # GET /rounds/new.xml
  def new # {{{
    @round = Round.new

  end # }}}

  # TODO: Obsolete. A round shouldnt be changed directly by the user after creation in any way. In a more
  # stable state of this application, this will be removed.
  # The only changes on a current round will be the state. but this should NOT
  # be accessible by the user.
  #
  # GET /rounds/1/edit
  def edit # {{{
    @round = Round.find(params[:id])
  end # }}}

  # POST /rounds
  # POST /rounds.xml
  def create # {{{
    @round = Round.new(params[:round])

    @round.state = Round::RUNNING

    if @round.save
      session[:round_id] = @round.id
    end
    redirect_to game_path
  end # }}}

  # TODO: Obsolete: mentioned above! ^^
  #
  # PUT /rounds/1
  # PUT /rounds/1.xml
  def update # {{{
    @round = Round.find(params[:id])

    respond_to do |format|
      if @round.update_attributes(params[:round])
        flash[:notice] = 'Round was successfully updated.'
        format.html { redirect_to(@round) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @round.errors, :status => :unprocessable_entity }
      end
    end
  end # }}}

  # This will be called by the exit button beneath the gaming field.
  # Just the destruction of the current round - no highscore, no glory!!
  #
  # DELETE /rounds/1
  # DELETE /rounds/1.xml
  def destroy # {{{
    @round = Round.find(params[:id])
    # the round needs only to be deleted, when its still running. An ended game
    # shall resist for the usage in the highscores.
    @round.destroy if @round.state == Round::RUNNING

    session[:round_id] = nil

    redirect_to root_path  
  end # }}}
end
