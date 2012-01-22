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
      render 'questions/show'
    end
  end

end
