class AnswersController < ApplicationController
  before_filter :authenticate, only: [:create, :accept, :vote]

  def create
    @question = Question.find params[:question_id]
    @answer = @question.answers.build params[:answer]
    current_user.answers << @answer

    if @answer.save
      flash[:success] = "Answer created!"
      redirect_to @question
    else
      @question.reload
      render "questions/show"
    end
  end

  def accept
    @accepted_answer = Answer.find params[:id]
    @question = @accepted_answer.question
    @question.accept! @accepted_answer
    respond_to do |format|
      format.html { redirect_to @question }
      format.js
    end 
  end

  def vote
    @voted_answer = Answer.find params[:id]
    current_user.vote! @voted_answer
    @question = @voted_answer.question
    respond_to do |format|
      format.html { redirect_to @question }
      format.js
    end
  end
end
