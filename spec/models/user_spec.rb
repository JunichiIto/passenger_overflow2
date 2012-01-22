# -*- coding: utf-8 -*-
require 'spec_helper'

describe User do
  before(:each) do
    @attr = { :user_name => "junichiito" }
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
    long_name_user = User.new(@attr.merge(:user_name => long_name))
    long_name_user.should_not be_valid
  end

  it "should reject invalid user_names" do
    names = ['UpperCase', 'Include Space', 'にほんご', 'symbol#$%etc']
    names.each do |name|
      invalid_user_name_user = User.new(@attr.merge(:user_name => name))
      invalid_user_name_user.should_not be_valid
    end
  end

  it "should reject duplicate user_names" do
    User.create! @attr
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.should_not be_valid
  end

  describe "authenticate method" do
    before :each do
      @user = User.create! @attr
    end

    it "should return the user on match" do
      matching_user = User.authenticate(@attr[:user_name])
      matching_user.should == @user
    end

    it "should return nil on unmatch" do
      matching_user = User.authenticate('foobar')
      matching_user.should be_nil
    end
  end

  describe "question associations" do
    before :each do
      @user = User.create! @attr
      @q1 = Factory :question, :user => @user, :created_at => 1.day.ago
      @q2 = Factory :question, :user => @user, :created_at => 1.hour.ago
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
      asker = Factory :user, user_name: 'someone'
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
end
