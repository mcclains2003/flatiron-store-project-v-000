class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def set_user
    @user = current_user
  end

  def check_logged_in?
    if !user_signed_in?
      redirect_to new_user_session_path
    end
  end

  def alias_to
    @current_cart = current_user.current_cart unless !current_user
  end
end
