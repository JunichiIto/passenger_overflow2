module ApplicationHelper
  def render_user(user)
    link_to(user.user_name, user) + " " + user.reputation_point.to_s
  end
end
