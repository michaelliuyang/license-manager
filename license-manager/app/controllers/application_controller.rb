class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :check_session,:except => [:login,:exit]
  before_filter :validate_user_logined,:except => [:login,:exit]
  
  def exit
    reset_session
    redirect_to login_users_path
  end
  
  protected
  
  def render_login_page
    render :action => 'login',:layout => 'login_layout'
  end
  
  def validate_is_admin
    redirect_to licenses_url unless session[:user][:is_admin]
  end
  
  private
  
  def check_session
    reset_session if session[:last_active] && session[:last_active] < 20.minutes.ago
    session[:last_active] = Time.now
  end
  
  def validate_user_logined
    redirect_to login_users_url unless session[:user] == nil ? false : true
  end
    
end
