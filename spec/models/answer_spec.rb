require 'spec_helper'

describe Answer do
  before :each do
    @user = Factory :user 
    @asker = Factory :user, :user_name => 'someone'
    @question = Factory :question, :user => @asker
  end

  it "should create a new instance given valid attributes" do
    answer = @user.answers.build question: @question, content: "my ans"
    @question.answers << answer
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

  describe "validations" do
    before :each do
      @attr = { content: "my ans", user: @user, question: @question }
    end

    it "should require a user id" do
      no_user = Answer.new(@attr.merge(user: nil))
      no_user.should_not be_valid
    end

    it "should require a question id" do
      no_question = Answer.new(@attr.merge(quetion: nil))
      no_question.should_not be_valid
    end

    it "should require nonblank content" do
      #@user.microposts.build(:content => "  ").should_not be_valid
      no_content = Answer.new(@attr.merge(content: "  "))
      no_content.should_not be_valid
    end
  end
end
