require 'spec_helper'

describe "Users" do
  describe "signup" do
    describe "failure" do
      it "should not make a new user" do
        lambda do
          visit new_user_path
          fill_in "User name", with: ""
          click_button
          response.should render_template "users/new"
          response.should have_selector "div#error_explanation"
        end.should_not change(User, :count)
      end
    end

    describe "success" do
      it "should make a new user" do
        lambda do
          visit new_user_path
          fill_in "User name", with: "junichiito"
          click_button
          response.should have_selector "p.flash.success", content: "Welcome"
          response.should render_template "users/show"
        end.should change(User, :count).by(1)
      end
    end
  end

  describe "sign in/out" do
    describe "failure" do
      it "should not sign a user in" do
        visit new_session_path
        fill_in "User name", with: ""
        click_button
        response.should have_selector "p.flash.error", content: "Invalid"
      end
    end

    describe "success" do
      it "should sign a user in and out" do
        user = Factory :user
        visit new_session_path
        fill_in "User name", with: user.user_name
        click_button
        controller.should be_signed_in
        click_link "Sign out", method: :delete
        controller.should_not be_signed_in
      end
    end
  end
end
