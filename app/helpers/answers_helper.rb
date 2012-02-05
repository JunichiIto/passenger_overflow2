module AnswersHelper
  def can_vote?(answer)
    signed_in? && 
    !current_user.already_voted?(answer) && 
    answer.user != current_user
  end
end
