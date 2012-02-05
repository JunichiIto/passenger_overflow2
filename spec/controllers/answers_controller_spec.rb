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
        response.should redirect_to @question
      end

      it "should have a flash message" do
        post :create, :question_id => @question, :answer => @attr
        flash[:success].should =~ /answer created/i
      end
    end
  end

  describe "post 'accept'" do
    before(:each) do
      @user = test_sign_in(Factory(:user))
      @asker = Factory :user, user_name: "beginner"
      @question = Factory :question, :user => @asker
      @answer = Factory :answer, :question => @question, :user => @user
      second = Factory :answer, :question => @question, :user => @user, :created_at => 1.day.ago
      third = Factory :answer, :question => @question, :user => @user, :created_at => 1.hour.ago
    end

    it "should accept an answer" do
      question = @answer.question
      question.accepted_answer.should be_nil
      lambda do
        post 'accept', :id => @answer
        question.reload
      end.should change(question, :accepted_answer).from(nil).to(@answer)
    end

    it "should redirect to the question page" do
      post 'accept', :id => @answer
      response.should redirect_to @question
    end

    it "should have a flash message" do
      post 'accept', :id => @answer
      flash[:success].should =~ /answer has been accepted/i
    end
  end

  describe "post 'vote'" do
    before(:each) do
      @user = Factory(:user)
      @asker = Factory :user, user_name: "beginner"
      @question = Factory :question, :user => @asker
      @answer = Factory :answer, :question => @question, :user => @user
      test_sign_in @asker
    end

    it "should increment votes count in answer after vote cast" do
      lambda do
        post 'vote', :id => @answer
        @answer.votes.reload
      end.should change(@answer.votes, :size).from(0).to(1)
    end

    it "should increment votes count in asker after vote cast" do
      lambda do
        post 'vote', :id => @answer
      end.should change(@asker.votes, :size).by(1)
    end

    it "should redirect to the question page" do
      post 'vote', :id => @answer
      response.should redirect_to @question
    end

    it "should have a flash message" do
      post 'vote', :id => @answer
      flash[:success].should =~ /your vote has been saved/i
    end
  end

  describe "access control" do
    before(:each) do
      @user = Factory :user
      @asker = Factory :user, user_name: "beginner"
      @question = Factory :question, :user => @asker
      @answer = Factory :answer, :question => @question, :user => @user
      test_sign_out
    end

    it "should deny access to 'create'" do
      post :create, question_id: 1
      response.should redirect_to(signin_path)
    end

    it "should deny access to 'accept'" do
      post 'accept', :id => @answer
      response.should redirect_to(signin_path)
    end
    
    it "should deny access to 'vote'" do
      post 'vote', :id => @answer
      response.should redirect_to(signin_path)
    end
  end
end
