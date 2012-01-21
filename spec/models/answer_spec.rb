require 'spec_helper'

describe Answer do
  before(:each) do
    @user = Factory(:user)
    @attr = { :content => "value for content" }
  end

  it "should create a new instance given valid attributes" do
    @user.answers.create!(@attr)
  end

  describe "user associations" do
    before(:each) do
      @answer = @user.answers.create(@attr)
    end

    it "should have a user attribute" do
      @answer.should respond_to(:user)
    end

    it "should have the right associated user" do
      @answer.user_id.should == @user.id
      @answer.user.should == @user
    end
  end
end
