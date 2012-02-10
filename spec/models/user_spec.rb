# -*- coding: utf-8 -*-
require 'spec_helper'

describe User do
  before do
    @attr = { user_name: "junichiito" }
  end

  describe "validations" do
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
  end

  describe "authenticate method" do
    before do
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
    before do
      @user = User.create! @attr
      @question1 = Factory :question, user: @user, created_at: 1.day.ago
      @question2 = Factory :question, user: @user, created_at: 1.hour.ago
    end

    it "should have a questions attribute" do
      @user.should respond_to :questions
    end

    it "should have the right questions in the right order" do
      @user.questions.should == [@question2, @question1]
    end
  end

  describe "answer associations" do
    before do
      @user = Factory :user
      asker = Factory :user, user_name: "someone"
      question = Factory :question, user: asker
      @answer1 = Factory :answer, question: question, user: @user, created_at: 1.day.ago
      @answer2 = Factory :answer, question: question, user: @user, created_at: 1.hour.ago
    end

    it "should have a answers attribute" do
      @user.should respond_to :answers
    end

    it "should have the right answers in the right order" do
      @user.answers.should == [@answer2, @answer1]
    end
  end

  describe "vote associations" do
    before do
      @user = Factory :user
      @asker = Factory :user, user_name: "someone"
      question = Factory :question, user: @asker
      @answer = Factory :answer, question: question, user: @user
      @my_own_answer = Factory :answer, question: question, user: @asker
    end

    it "should have a votes attribute" do
      @asker.should respond_to :votes
    end

    it "should increment votes count in user after vote cast" do
      lambda do
        @asker.vote! @answer
      end.should change(@asker.votes, :size).by(1)      
    end

    it "should increment votes count in answer after vote cast" do
      lambda do
        @asker.vote! @answer
      end.should change(@answer.votes, :count).by(1)
    end  
    
    it "should be already voted after vote cast" do
      @asker.already_voted?(@answer).should be_false
      @asker.vote! @answer
      @asker.already_voted?(@answer).should be_true
    end

    it "should increase teacher's reputation" do
      lambda do
        @asker.vote! @answer
      end.should change(@user.reputations, :size).from(0).to(1)
    end

    it "should have the right reputation" do
      vote = @asker.vote! @answer
      rep = @user.reputations.pop
      rep.activity.should == vote
      rep.reason.should == "upvote"
      rep.point.should == 10
    end

    describe "can_vote?" do
      it "should have a can_vote? method" do
        @asker.should respond_to :can_vote?
      end
    
      it "should be okay" do
        @asker.can_vote?(@answer).should be_true
      end

      describe "when already voted" do
        before do
          @asker.vote! @answer
        end
  
        it "should not be okay" do
          @asker.can_vote?(@answer).should_not be_true
        end
      end

      describe "when my own answer" do
        it "should not be okay" do
          @asker.can_vote?(@my_own_answer).should_not be_true
        end
      end
    end
  end

  describe "reputation associations" do
    before do
      @user = Factory :user
      asker = Factory :user, user_name: "someone"
      other = Factory :user, user_name: "other"
      question = Factory :question, user: asker
      answer = Factory :answer, question: question, user: @user
      vote1 = Factory :vote, user: asker, answer: answer
      vote2 = Factory :vote, user: other, answer: answer
      @reputation1 = Factory :reputation, user: @user, activity: vote1, created_at: 1.day.ago
      @reputation2 = Factory :reputation, user: @user, activity: vote2, created_at: 1.hour.ago
    end    

    it "should have the right reputations in the right order" do
      @user.reputations.should == [@reputation2, @reputation1]
    end
  end

  describe "reputation points" do
    before do
      @user = Factory :user
      asker = Factory :user, user_name: "someone"
      other = Factory :user, user_name: "other"
      question = Factory :question, user: asker
      answer = Factory :answer, question: question, user: @user
      vote = Factory :vote, user: asker, answer: answer

      #user answers a question and is accepted and voted
      answer.accepted!
      other.vote! answer

      #user asks a question and accept answer
      my_question = Factory :question, user: @user
      ans_to_my_question = Factory :answer, question: my_question, user: other
      ans_to_my_question.accepted! 
    end    

    it "should have 3 reputations" do
      @user.reputations.size.should == 3
    end

    it "should have the right reputation point" do
      @user.reputation_point.should == 27
    end
  end
end
