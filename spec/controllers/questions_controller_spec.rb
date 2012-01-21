require 'spec_helper'

describe QuestionsController do
  render_views

  describe "GET 'index'" do
    it "should be successful" do
      get 'index'
      response.should be_success
    end

    it "should have the right title" do
      get :index
      response.should have_selector("h2", :content => "Questions")
    end
  end

  describe "access control" do
    it "should deny access to 'create'" do
      get :new
      response.should redirect_to(signin_path)
    end

    it "should deny access to 'create'" do
      post :create
      response.should redirect_to(signin_path)
    end
  end

  describe "GET 'new'" do
    before(:each) do
      @user = test_sign_in(Factory(:user))
    end
    it "should be successful" do
      get 'new'
      response.should be_success
    end

    it "should have the right title" do
      get 'new'
      response.should have_selector("h2", :content => "Ask Question")
    end
  end
end
