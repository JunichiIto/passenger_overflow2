require 'spec_helper'

describe QuestionsController do
  render_views

  describe "GET 'index'" do
    before(:each) do
      user = Factory :user
      @question = Factory :question, :user => user
      second = Factory :question, :user => user, :created_at => 1.day.ago
      third = Factory :question, :user => user, :created_at => 1.hour.ago

      @questions = [@question, second, third]
    end

    it "should be successful" do
      get 'index'
      response.should be_success
    end

    it "should have the right title" do
      get :index
      response.should have_selector("h2", :content => "Questions")
    end

    it "should have an element for each question" do
      get :index
      @questions.each do |question|
        response.should have_selector("li", :content => question.title)
      end
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

  describe "POST 'create'" do
    before(:each) do
      @user = test_sign_in(Factory(:user))
    end

    describe "failure" do
      before(:each) do
        @attr = { :title => "", :content => "" }
      end

      it "should not create a question" do
        lambda do
          post :create, :question => @attr
        end.should_not change(Question, :count)
      end

      it "should render the new page" do
        post :create, :question => @attr
        response.should render_template('new')
      end
    end

    describe "success" do
      before(:each) do
        @attr = { :title => "valid title", :content => "Hello there!" }
      end

      it "should create a question" do
        lambda do
          post :create, :question => @attr
        end.should change(Question, :count).by(1)
      end

      it "should redirect to the home page" do
        post :create, :question => @attr
        response.should redirect_to(root_path)
      end

      it "should have a flash message" do
        post :create, :question => @attr
        flash[:success].should =~ /question created/i
      end
    end
  end
end
