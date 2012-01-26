class AnswersController < ApplicationController
  before_filter :authenticate, :only => [:create]
  def create
    @question = Question.find params[:question_id]
    @answer = @question.answers.build params[:answer]
    current_user.answers << @answer
    if @answer.save
      flash[:success] = "Answer created!"
      redirect_to @question
    else
      @question = Question.find params[:question_id]
      render 'questions/show'
    end
  end

  def accept
    answer = Answer.find params[:id]
    question = answer.question
    question.update_attribute :accepted_answer_id, answer
    flash[:success] = "Answer has been accepted!"
    redirect_to question
  end
end
