require 'spec_helper'

describe AnswersController do
  render_views

  describe "POST 'create'" do
    before do
      @user = Factory :user
      test_sign_in @user
      asker = Factory :user, user_name: "beginner"
      @question = Factory :question, user: asker
    end

    describe "failure" do
      before do
        @attr = { content: "" }
      end

      it "should not create an answer" do
        lambda do
          post :create, question_id: @question, answer: @attr
        end.should_not change(Answer, :count)
      end

      it "should render the question page." do
        post :create, question_id: @question, answer: @attr
        response.should render_template "questions/show"
      end
    end

    describe "success" do
      before do
        @attr = { content: "Lorem ipsum" }
      end

      it "should create an answer" do
        lambda do
          post :create, question_id: @question, answer: @attr
        end.should change(Answer, :count).by(1)
      end

      it "should redirect to the question page" do
        post :create, question_id: @question, answer: @attr
        response.should redirect_to @question
      end

      it "should have a flash message" do
        post :create, question_id: @question, answer: @attr
        flash[:success].should =~ /answer created/i
      end
    end
  end

  describe "post 'accept'" do
    before do
      user = Factory :user
      test_sign_in user
      asker = Factory :user, user_name: "beginner"
      @question = Factory :question, user: asker
      @answer = Factory :answer, question: @question, user: user
    end

    it "should accept an answer using Ajax" do
      @question.accepted_answer.should be_nil
      lambda do
        xhr :post, :accept, question_id: @question, id: @answer
        response.should be_success
        response.should have_selector "span", content: "Accepted"
        @question.reload
      end.should change(@question, :accepted_answer).from(nil).to(@answer)
    end
    
    describe "when already accepted" do
      before do
        other = Factory :user, user_name: "other"
        another_answer = Factory :answer, question: @question, user: other
        @question.accept another_answer
      end

      it "should not accept twice" do
        @question.accepted_answer.should_not be_nil
        lambda do
          xhr :post, :accept, question_id: @question, id: @answer
          response.should be_success
          response.should have_selector "span", content: "Already accepted"
          @question.reload
        end.should_not change(@question, :accepted_answer)
      end
    end
  end

  describe "post 'vote'" do
    before do
      user = Factory :user
      @asker = Factory :user, user_name: "beginner"
      question = Factory :question, user: @asker
      @answer = Factory :answer, question: question, user: user
      test_sign_in @asker
    end

    it "should increment votes count in answer after vote cast using ajax" do
      lambda do
        xhr :post, :vote, question_id: @answer.question, id: @answer
        response.should be_success
        response.should have_selector "span", content: "1 vote"
        @answer.votes.reload
      end.should change(@answer.votes, :size).from(0).to(1)
    end

    it "should increment votes count in asker after vote cast using ajax" do
      lambda do
        xhr :post, :vote, question_id: @answer.question, id: @answer
        response.should be_success
        response.should have_selector "span", content: "1 vote"
        @answer.votes.reload
      end.should change(@asker.votes, :size).by(1)
    end

    describe "when already voted" do
      before do
        @asker.vote @answer
      end

      it "should not increment votes count in answer" do
        lambda do
          xhr :post, :vote, question_id: @answer.question, id: @answer
          response.should be_success
          response.should have_selector "span", content: "Already voted"
          response.should have_selector "span", content: "1 vote"
          @answer.votes.reload
        end.should_not change(@answer.votes, :size)
      end

      it "should not increment votes count in asker" do
        lambda do
          xhr :post, :vote, question_id: @answer.question, id: @answer
          response.should be_success
          response.should have_selector "span", content: "Already voted"
          response.should have_selector "span", content: "1 vote"
          @asker.votes.reload
        end.should_not change(@asker.votes, :size)
      end
    end
  end

  describe "access control" do
    before do
      user = Factory :user
      asker = Factory :user, user_name: "beginner"
      question = Factory :question, user: asker
      @answer = Factory :answer, question: question, user: user
      test_sign_out
    end

    it "should deny access to 'create'" do
      post :create, question_id: 1
      response.should redirect_to new_session_path
    end

    it "should deny access to 'accept'" do
      post :accept, question_id: @answer.question, id: @answer
      response.should redirect_to new_session_path
    end
    
    it "should deny access to 'vote'" do
      post :vote, question_id: @answer.question, id: @answer
      response.should redirect_to new_session_path
    end
  end
end
