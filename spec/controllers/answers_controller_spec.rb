require 'spec_helper'

describe AnswersController do
  render_views

  describe "POST 'create'" do
    before(:each) do
      @user = test_sign_in(Factory(:user))
      asker = Factory :user, user_name: "beginner"
      @question = Factory :question, :user => asker
    end

    describe "failure" do
      before(:each) do
        @attr = { :content => "" }
      end

      it "should not create an answer" do
        lambda do
          post :create, :question_id => @question, :answer => @attr
        end.should_not change(Answer, :count)
      end

      it "should render the question page." do
        post :create, :question_id => @question, :answer => @attr
        response.should render_template('questions/show')
      end
    end

    describe "success" do
      before(:each) do
        @attr = { :content => "Lorem ipsum" }
      end

      it "should create an answer" do
        lambda do
          post :create, :question_id => @question, :answer => @attr
        end.should change(Answer, :count).by(1)
      end

      it "should redirect to the question page" do
        post :create, :question_id => @question, :answer => @attr
        response.should redirect_to(question_path(assigns(:question)))
      end

      it "should have a flash message" do
        post :create, :question_id => @question, :answer => @attr
        flash[:success].should =~ /answer created/i
      end
    end
  end

  describe "access control" do
    it "should deny access to 'create'" do
      post :create, question_id: 1
      response.should redirect_to(signin_path)
    end
  end
end
