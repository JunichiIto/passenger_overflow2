class AnswersController < ApplicationController
  before_filter :authenticate, :only => [:create, :accept, :vote]
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
    @question = answer.question
    @question.accept answer
    flash[:success] = "Answer has been accepted!"
    redirect_to @question
  end

  def vote
  end
end
