module SessionsHelper
  def sign_in(user)
    cookies.permanent.signed[:remember_token] = [user.user_name]
    self.current_user = user
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user
    @current_user ||= user_from_remember_token
  end

  def signed_in?
    !current_user.nil?
  end

  def sign_out
    cookies.delete :remember_token
    self.current_user = nil
  end

  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    clear_return_to
  end

  def authenticate
    deny_access unless signed_in?
  end

  def deny_access
    store_location
    redirect_to new_session_path, notice: "Please sign in to access this page."
  end

  private
    def user_from_remember_token
      User.authenticate *remember_token
    end

    def remember_token
      cookies.signed[:remember_token] || [nil]
    end

    def store_location
      session[:return_to] = request.fullpath
    end

    def clear_return_to
      session[:return_to] = nil
    end
end
