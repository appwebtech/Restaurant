class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :current_chef, :logged_in?
  
  def current_chef
  	@current_chef ||= Chef.find(session[:chef_id]) if session[:chef_id] # If @currentchef is there, return it right away, if not grab current chef then return it.
  end

  def logged_in?
  	!!current_chef    
  end

  def require_user
  	if !logged_in?   # if not logged_in
  		flash[:danger] = "Devi eseguire l'accesso per complettare la richiesta"
  		redirect_to root_path
  	end
  end
end
