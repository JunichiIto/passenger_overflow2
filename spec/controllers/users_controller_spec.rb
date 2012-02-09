require 'spec_helper'

describe UsersController do
  render_views

  describe "GET 'index'" do
    before do
      @user = Factory :user
      second = Factory :user, user_name: "tanakagonzo"
      third  = Factory :user, user_name: "satonenpei"

      @users = [@user, second, third]
    end

    it "should be successful" do
      get :index
      response.should be_success
    end

    it "should have the right title" do
      get :index
      response.should have_selector "h2", content: "All users"
    end

    it "should have an element for each user" do
      get :index
      @users.each do |user|
        response.should have_selector "li", content: user.user_name
      end
    end
  end

  describe "GET 'show'" do
    before do
      @user = Factory :user
      asker = Factory :user, user_name: "someone"
      other = Factory :user, user_name: "other"
      question = Factory :question, user: asker
      answer = Factory :answer, question: question, user: @user

      #user answers a question and is accepted and voted
      answer.accepted!
      other.vote! answer

      #user asks a question and accept answer
      my_question = Factory :question, user: @user
      ans_to_my_question = Factory :answer, question: my_question, user: other
      ans_to_my_question.accepted!

      get :show, id: @user
    end

    it "should be successful" do
      response.should be_success
    end

    it "should have the right title" do
      response.should have_selector "h2", content: @user.user_name
    end

    it "should find the right user" do
      assigns(:user).should == @user
    end

    it "should have the right reputation point" do
      response.should have_selector "h3", content: "27 Reputation"
    end

    it "should have the right reputation history" do
      @user.reputations.each do |rep|
        response.should have_selector "a", content: rep.question.title
        response.should have_selector "td", content: rep.point.to_s
        response.should have_selector "td", content: rep.reason
      end
    end

    describe "when no reputations" do
      before do
        get :show, id: Factory(:user, user_name: "newmember")
      end

      it "should have the right reputation point" do
        response.should have_selector "h3", content: "0 Reputation"
      end

      it "should have no reputation history" do
        response.should_not have_selector "table"
      end
    end
  end

  describe "GET 'new'" do
    it "should be successful" do
      get :new
      response.should be_success
    end

    it "should have the right title" do
      get :new
      response.should have_selector "h2", content: "Sign up"
    end
  end

  describe "POST 'create'" do
    describe "failure" do
      before do
        @attr = { user_name: "" }
      end

      it "should not create a user" do
        lambda do
          post :create, user: @attr
        end.should_not change(User, :count)
      end

      it "should render the 'new' page" do
        post :create, user: @attr
        response.should render_template "new"
      end
    end

    describe "success" do
      before do
        @attr = { user_name: "junichiito" } 
      end

      it "should create a user" do
        lambda do
          post :create, user: @attr
        end.should change(User, :count).by(1)
      end

      it "should redirect to the user show page" do
        post :create, user: @attr
        response.should redirect_to user_path assigns :user
      end
    
      it "should have a welcome message" do
        post :create, user: @attr
        flash[:success].should =~ /welcome/i
      end

      it "should sign the user in" do
        post :create, user: @attr
        controller.should be_signed_in
      end
    end
  end
end
