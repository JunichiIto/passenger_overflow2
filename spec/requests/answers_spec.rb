require 'spec_helper'

describe "Answers" do
  before :each do
    user = Factory :user
    visit signin_path
    fill_in :session_user_name, with: user.user_name
    click_button
    
    asker = Factory :user, user_name: "beginner"
    @question = Factory :question, user: asker
  end

  describe "creation" do
    describe "failure" do
      it "should not make a new answer" do
        lambda do
          visit question_path @question
          fill_in :answer_content, with: ""
          click_button
          response.should render_template "questions/show"
          response.should have_selector "div#error_explanation"
        end.should_not change(Answer, :count)
      end
    end

    describe "success" do
      it "should make a new answer" do
        content = "Lorem ipsum dolor sit amet"
        lambda do
          visit question_path @question
          fill_in :answer_content, with: content
          click_button
          response.should have_selector "p", content: content
        end.should change(Answer, :count).by(1)
      end
    end
  end
end
