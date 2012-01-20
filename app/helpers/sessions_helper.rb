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

  private
    def user_from_remember_token
      User.authenticate(*remember_token)
    end

    def remember_token
      cookies.signed[:remember_token] || [nil]
    end
end
