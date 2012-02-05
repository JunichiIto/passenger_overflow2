module ApplicationHelper
  def render_model_info(model)
    "[ #{model.created_at.to_s} #{render_user(model.user)} ]".html_safe
  end

  def render_user(user)
    "#{link_to(user.user_name, user)} #{user.reputation_point.to_s}"
  end
end
