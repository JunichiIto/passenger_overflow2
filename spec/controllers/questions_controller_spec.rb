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
        response.should have_selector("div.title", :content => question.title)
      end
    end
  end

  describe "GET 'show'" do
    before(:each) do
      @asker = Factory :user, user_name: "beginner"
      @question = Factory :question, :user => @asker
      @user = Factory :user
      @answer = Factory :answer, :question => @question, :user => @user
      second = Factory :answer, :question => @question, :user => @user, :created_at => 1.day.ago
      third = Factory :answer, :question => @question, :user => @user, :created_at => 1.hour.ago

      @answers = [@answer, second, third]
    end

    it "should be successful" do
      get :show, :id => @question
      response.should be_success
    end

    it "should have the right title" do
      get :show, :id => @question
      response.should have_selector("h2", :content => @question.title)
    end

    it "should find the right question" do
      get :show, :id => @question
      assigns(:question).should == @question
    end

    it "should have an element for each answer" do
      get :show, :id => @question
      @answers.each do |answer|
        response.should have_selector("p", :content => answer.content)
      end
    end
    
    describe "when not signed in" do
      it "should not have textarea for answer" do
        get :show, :id => @question
        response.should_not have_selector("textarea")
      end
    end
    
    describe "when signed in" do
      before :each do
        test_sign_in @user
      end
      
      it "should have textarea for answer" do
        get :show, :id => @question
        response.should have_selector("textarea")
      end
    end
    
    describe "accept links" do
      describe "when asker signed in" do
        before :each do
          test_sign_in @asker
        end
      
        describe "not accepted yet" do
          it "should have accept links" do
            get :show, :id => @question
            response.should have_selector("a", :content => "Accept")
          end
        end
      end

      describe "when other signed in" do
        before :each do
          test_sign_in @user
        end
      
        it "should not have accept links" do
          get :show, :id => @question
          response.should_not have_selector("a", :content => "Accept")
        end
      end

      describe "when not signed in" do
        it "should not have accept links" do
          get :show, :id => @question
          response.should_not have_selector("a", :content => "Accept")
        end
      end

      describe "already accepted" do
        before :each do
          test_sign_in @asker
          @question.update_attribute :accepted_answer_id, @answer
        end
    
        it "should already accepted" do
          @question.should be_accepted
        end
      
        it "should not have accept links" do
          get :show, :id => @question
          response.should_not have_selector("a", :content => "Accept")
        end

        it "should indicate an answer has been accepted" do
          get :show, :id => @question
          response.should have_selector("span", :content => "Accepted")
        end
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

      it "should redirect to the question page" do
        post :create, :question => @attr
        #response.should redirect_to(root_path)
        response.should redirect_to(question_path(assigns(:question)))
      end

      it "should have a flash message" do
        post :create, :question => @attr
        flash[:success].should =~ /question created/i
      end
    end
  end
end
