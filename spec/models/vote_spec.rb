require 'spec_helper'

describe Vote do
  it "should have an answer attribute" do
    Vote.new.should respond_to :answer
  end
  it "should have an user attribute" do
    Vote.new.should respond_to :user
  end
  
  describe "validations" do
    before :each do
      @user = Factory :user
      @asker = Factory :user, user_name: "someone"
      question = Factory :question, user: @asker
      @answer = Factory :answer, question: question, user: @user, created_at: 1.day.ago
    end

    it "should require a user id" do
      Vote.new(answer: @answer).should_not be_valid
    end

    it "should require an answer id" do
      Vote.new(user: @asker).should_not be_valid
    end
  end
end
