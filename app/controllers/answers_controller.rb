class AnswersController < ApplicationController
  before_filter :authenticate, :only => [:create]
  def create
  end

end
