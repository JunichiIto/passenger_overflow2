require 'spec_helper'

describe Reputation do
  before do
    @asker = Factory :user
    @question = Factory :question, user: @asker
    @teacher = Factory :user, user_name: "hacker"
    @answer = Factory :answer, user: @teacher, question: @question
    @vote = Factory :vote, user: @asker, answer: @answer

    @vote_attr = { activity_id: @vote,
                   activity_type: "Vote", 
                   reason: "upvote", 
                   point: 10 }

    @accept_attr = { activity_id: @answer,
                     activity_type: "Answer", 
                     reason: "accept", 
                     point: 15 }

    @accepted_attr = { activity_id: @answer,
                       activity_type: "Answer", 
                       reason: "accepted", 
                       point: 2 }
  end  

  describe "user associations" do
    before do
      @reputation = @teacher.reputations.create @vote_attr
    end

    it "should have a user attribute" do
      @reputation.should respond_to :user
    end

    it "should have the right associated user" do
      @reputation.user_id.should == @teacher.id
      @reputation.user.should == @teacher
    end
  end

  describe "vote associations" do
    before do
      @reputation = @teacher.reputations.create @vote_attr
    end

    it "should have the right associated vote" do
      @reputation.activity_id.should == @vote.id
      @reputation.activity.should == @vote
    end
  
    it "should return the right question" do
      @reputation.question.should == @question
    end
  end

  describe "accept associations" do
    before do
      @reputation = @teacher.reputations.create @accept_attr
    end

    it "should have the right associated answer" do
      @reputation.activity_id.should == @answer.id
      @reputation.activity.should == @answer
    end
  
    it "should return the right question" do
      @reputation.question.should == @question
    end
  end

  describe "accepted associations" do
    before do
      @reputation = @teacher.reputations.create @accepted_attr
    end

    it "should have the right associated answer" do
      @reputation.activity_id.should == @answer.id
      @reputation.activity.should == @answer
    end
  
    it "should return the right question" do
      @reputation.question.should == @question
    end
  end
end
