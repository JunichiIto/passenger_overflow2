class QuestionsController < ApplicationController
  before_filter :authenticate, :only => [:new, :create]

  def index
  end

  def new
    @question = Question.new
  end

  def create
    @question  = current_user.questions.build(params[:question])
    if @question.save
      flash[:success] = "Question created!"
      redirect_to root_path
    else
      render 'new'
    end
  end
end
