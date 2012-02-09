class AnswersController < ApplicationController
  before_filter :authenticate, only: [:create, :accept, :vote]
  before_filter :load_question

  def create
    @answer = @question.answers.build params[:answer]
    @answer.user = current_user

    if @answer.save
      flash[:success] = "Answer created!"
      redirect_to @question
    else
      # remove unsaved record.
      @question.reload
      render "questions/show"
    end
  end

  def accept
    @selected_answer = Answer.find params[:id]
    @selected_answer.accepted!
    respond_to do |format|
      format.html { redirect_to @question }
      format.js
    end 
  end

  def vote
    @voted_answer = Answer.find params[:id]
    current_user.vote! @voted_answer
    respond_to do |format|
      format.html { redirect_to @question }
      format.js
    end
  end

  private
  def load_question
    @question = Question.find params[:question_id]
  end
end
