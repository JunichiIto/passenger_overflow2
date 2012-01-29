module ApplicationHelper
  def render_user(user)
    user.user_name + " " + user.reputation_point.to_s
  end
end
