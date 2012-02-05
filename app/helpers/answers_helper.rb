module AnswersHelper
  def render_accept_section(answer)
    if @question.accepted?
      if @question.accepted_answer_id == answer.id
        render_accepted
      end
    else
      if current_user == @question.user
        content_tag :span, id="accept#{answer.id}" do
          link_to "Accept", 
                  accept_answer_path(answer), 
                  method: :post, 
                  remote: true, 
                  style: "display:inline;", 
                  id: "accept#{answer.id}"
        end
      end
    end
  end

  def render_accepted
    content_tag :span, "Accepted", class: "accepted"
  end

  def render_vote_section(answer)
    if signed_in? && current_user.already_voted?(answer)
      content_tag :span, pluralize(answer.votes.count, "vote"), class: "voted"
    else
      tag = content_tag :span, pluralize(answer.votes.count, "vote")
      if signed_in? && answer.user != current_user
        tag += link_to "Vote+", vote_answer_path(answer), method: :post, class: "vote"
      end
      tag
    end
  end
end
