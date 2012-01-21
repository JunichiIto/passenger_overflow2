class QuestionsController < ApplicationController
  before_filter :authenticate, :only => [:new, :create]

  def index
  end

  def new
    @question = Question.new
  end

  def create
  end
end
