class UserSession

  def initialize session
    @session = session
  end

  def has_round?
    true if @session[:round_id]
    false
  end

  def round= round
    @session[:round_id] = round.id   
  end

  def round
    @session[:round_id]
  end

end
