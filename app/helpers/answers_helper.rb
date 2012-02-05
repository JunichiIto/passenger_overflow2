module AnswersHelper
  def render_accepted
    content_tag "span", "Accepted", class: "accepted"
  end
end
