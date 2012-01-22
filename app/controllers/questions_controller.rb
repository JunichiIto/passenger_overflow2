class QuestionsController < ApplicationController
  before_filter :authenticate, :only => [:new, :create]

  def index
    @questions = Question.all
  end

  def show
    @question = Question.find(params[:id])
    @answer = Answer.new
  end

  def new
    @question = Question.new
  end

  def create
    @question  = current_user.questions.build(params[:question])
    if @question.save
      flash[:success] = "Question created!"
      redirect_to @question
    else
      render 'new'
    end
  end
end
