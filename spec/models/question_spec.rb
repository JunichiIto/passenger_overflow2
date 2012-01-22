require 'spec_helper'

describe Question do
  before :each do
    @user = Factory :user
    @attr = {
      :title => "value for title",
      :content => "value for content"
    }
  end

  describe "user associations" do
    before(:each) do
      @question = @user.questions.create(@attr)
    end

    it "should have a user attribute" do
      @question.should respond_to :user
    end

    it "should have the right associated user" do
      @question.user_id.should == @user.id
      @question.user.should == @user
    end
  end

  describe "validations" do
    it "should require a user id" do
      Question.new(@attr).should_not be_valid
    end

    it "should require nonblank title" do
      @user.questions.build(:title => "  ").should_not be_valid
    end

    it "should reject long title" do
      @user.questions.build(:title => "a" * 256).should_not be_valid
    end

    it "should require nonblank content" do
      @user.questions.build(:content => "  ").should_not be_valid
    end
  end

  describe "answer associations" do
    before(:each) do
      #@question = Question.create(@attr)
      #user = Factory :user
      asker = Factory :user, user_name: 'someone'
      @question = Factory :question, user: asker
      @a1 = Factory :answer, question: @question, user: @user, created_at: 1.day.ago
      @a2 = Factory :answer, question: @question, user: @user, created_at: 1.hour.ago
    end

    it "should have a answers attribute" do
      @question.should respond_to(:answers)
    end

    it "should have the right answers in the right order" do
      @question.answers.should == [@a2, @a1]
    end
  end
end
