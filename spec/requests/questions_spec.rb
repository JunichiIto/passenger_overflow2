require 'spec_helper'

describe "Questions" do
  before(:each) do
    user = Factory(:user)
    visit signin_path
    fill_in :session_user_name, :with => user.user_name
    click_button
  end

  describe "creation" do
    describe "failure" do
      it "should not make a new question with blank title" do
        lambda do
          visit new_question_path
          fill_in :question_title, :with => ""
          fill_in :question_content, :with => "Foo"
          click_button
          response.should render_template('new')
          response.should have_selector("div#error_explanation")
        end.should_not change(Question, :count)
      end

      it "should not make a new question with blank content" do
        lambda do
          visit new_question_path
          fill_in :question_title, :with => "Foo"
          fill_in :question_content, :with => ""
          click_button
          response.should render_template('new')
          response.should have_selector("div#error_explanation")
        end.should_not change(Question, :count)
      end
    end

    describe "success" do
      it "should make a new question" do
        title = "How are you?"
        content = "Lorem ipsum dolor sit amet"
        lambda do
          visit new_question_path
          fill_in :question_title, :with => title
          fill_in :question_content, :with => content
          click_button
          response.should have_selector("h2", :content => title)
        end.should change(Question, :count).by(1)
      end
    end
  end
end
