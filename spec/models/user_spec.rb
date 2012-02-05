# -*- coding: utf-8 -*-
require 'spec_helper'

describe User do
  before :each do
    @attr = { user_name: "junichiito" }
  end

  it "should create a new instance given valid attributes" do
    User.create! @attr
  end

  it "should require a name" do
    no_user_name_user = User.new
    no_user_name_user.should_not be_valid
  end

  it "should reject user_names that are too long" do
    long_name = "a" * 21
    long_name_user = User.new @attr.merge user_name: long_name
    long_name_user.should_not be_valid
  end

  it "should reject invalid user_names" do
    names = ["UpperCase", "Include Space", "にほんご", 'symbol#$%etc']
    names.each do |name|
      invalid_user_name_user = User.new @attr.merge user_name: name
      invalid_user_name_user.should_not be_valid
    end
  end

  it "should reject duplicate user_names" do
    User.create! @attr
    user_with_duplicate_email = User.new @attr
    user_with_duplicate_email.should_not be_valid
  end

  describe "authenticate method" do
    before :each do
      @user = User.create! @attr
    end

    it "should return the user on match" do
      matching_user = User.authenticate @attr[:user_name]
      matching_user.should == @user
    end

    it "should return nil on unmatch" do
      matching_user = User.authenticate "foobar"
      matching_user.should be_nil
    end
  end

  describe "question associations" do
    before :each do
      @user = User.create! @attr
      @q1 = Factory :question, user: @user, created_at: 1.day.ago
      @q2 = Factory :question, user: @user, created_at: 1.hour.ago
    end

    it "should have a questions attribute" do
      @user.should respond_to :questions
    end

    it "should have the right questions in the right order" do
      @user.questions.should == [@q2, @q1]
    end
  end

  describe "answer associations" do
    before :each do
      @user = Factory :user
      asker = Factory :user, user_name: "someone"
      question = Factory :question, user: asker
      @a1 = Factory :answer, question: question, user: @user, created_at: 1.day.ago
      @a2 = Factory :answer, question: question, user: @user, created_at: 1.hour.ago
    end

    it "should have a answers attribute" do
      @user.should respond_to :answers
    end

    it "should have the right answers in the right order" do
      @user.answers.should == [@a2, @a1]
    end
  end

  describe "vote associations" do
    before :each do
      @user = Factory :user
      @asker = Factory :user, user_name: "someone"
      question = Factory :question, user: @asker
      @a1 = Factory :answer, question: question, user: @user, created_at: 1.day.ago
    end

    it "should have a votes attribute" do
      @asker.should respond_to :votes
    end

    it "should increment votes count in user after vote cast" do
      lambda do
        @asker.vote! @a1
      end.should change(@asker.votes, :size).by(1)      
    end

    it "should increment votes count in answer after vote cast" do
      lambda do
        @asker.vote! @a1
      end.should change(@a1.votes, :count).by(1)
    end  
    
    it "should be already voted after vote cast" do
      @asker.already_voted?(@a1).should be_false
      @asker.vote! @a1
      @asker.already_voted?(@a1).should be_true
    end

    it "should increase teacher's reputation" do
      lambda do
        @asker.vote! @a1
      end.should change(@user.reputations, :size).from(0).to(1)
    end

    it "should have the right reputation" do
      vote = @asker.vote! @a1
      rep = @user.reputations.pop
      rep.activity.should == vote
      rep.reason.should == "upvote"
      rep.point.should == 10
    end
  end

  describe "reputation associations" do
    before :each do
      @user = Factory :user
      asker = Factory :user, user_name: "someone"
      other = Factory :user, user_name: "other"
      question = Factory :question, user: asker
      a1 = Factory :answer, question: question, user: @user
      v1 = Factory :vote, user: asker, answer: a1
      v2 = Factory :vote, user: other, answer: a1
      @r1 = Factory :reputation, user: @user, activity:v1, created_at: 1.day.ago
      @r2 = Factory :reputation, user: @user, activity:v2, created_at: 1.hour.ago
    end    

    it "should have the right reputations in the right order" do
      @user.reputations.should == [@r2, @r1]
    end
  end

  describe "reputation points" do
    before :each do
      @user = Factory :user
      asker = Factory :user, user_name: "someone"
      other = Factory :user, user_name: "other"
      question = Factory :question, user: asker
      a1 = Factory :answer, question: question, user: @user
      v1 = Factory :vote, user: asker, answer: a1

      #user answers a question and is accepted and voted
      question.accept! a1
      other.vote! a1

      #user asks a question and accept answer
      my_question = Factory :question, user: @user
      ans_to_my_question = Factory :answer, question: my_question, user: other
      my_question.accept! ans_to_my_question
    end    

    it "should have 3 reputations" do
      @user.reputations.size.should == 3
    end

    it "should have the right reputation point" do
      @user.reputation_point.should == 27
    end
  end
end
