module AnswersHelper
  def render_accept_section(answer)
    if @question.accepted?
      if @question.accepted_answer_id == answer.id
        render_accepted
      end
    else
      if current_user == @question.user
        content_tag :span, id: "accept#{answer.id}" do
          link_to "Accept", 
                  accept_answer_path(answer), 
                  method: :post, 
                  remote: true
        end
      end
    end
  end

  def render_accepted
    content_tag :span, "Accepted", class: "accepted"
  end

  def render_vote_count(answer)
    if signed_in? && current_user.already_voted?(answer)
      content_tag :span, 
                  pluralize(answer.votes.count, "vote"), 
                  class: "voted", 
                  id: "votecnt#{answer.id}"
    else
      content_tag :span, 
                  pluralize(answer.votes.count, "vote"), 
                  id: "votecnt#{answer.id}"
    end
  end    
  
  def can_vote?(answer)
    signed_in? && 
    !current_user.already_voted?(answer) && 
    answer.user != current_user
  end

  def render_answer_count(question)
    if question.accepted?
       content_tag :span, 
                    pluralize(question.answers.count, "Answer"), 
                    class: "accepted"
    else
      pluralize question.answers.count, "Answer"
    end
  end

  def render_vote_link(answer)
    if can_vote? answer
      content_tag :span, id: "votelink#{answer.id}" do
        link_to "Vote+", 
                vote_answer_path(answer), 
                method: :post, 
                class: "vote", 
                remote: true 
      end
    end
  end
end
