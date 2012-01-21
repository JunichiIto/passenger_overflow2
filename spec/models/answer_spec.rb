require 'spec_helper'

describe Answer do
  before :each do
    @user = Factory :user 
    asker = Factory :user, :user_name => 'someone'
    @question = Factory :question, :user => asker
  end

  it "should create a new instance given valid attributes" do
    answer = @user.answers.build question: @question
    answer.save!
  end

  describe "user associations" do
    before :each do
      @answer = Factory :answer, :user => @user, :question => @question
    end

    it "should have the right associated user" do
      @answer.user_id.should == @user.id
      @answer.user.should == @user
    end

    it "should have the right associated question" do
      @answer.question_id.should == @question.id
      @answer.question.should == @question
    end

    it "should have a user attribute" do
      @answer.should respond_to :user
    end

    it "should have a question attribute" do
      @answer.should respond_to :question
    end
  end
end
