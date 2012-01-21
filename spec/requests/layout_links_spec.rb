describe "Layout links" do
  describe "when not signed in" do
    it "should have a signin link" do
      visit root_path
      response.should have_selector("a", :href => signin_path,
                                         :content => "Sign in")
    end

    it "should have an ask question link" do
      visit root_path
      response.should have_selector("a", :href => new_question_path,
                                         :content => "Ask Question")
    end
  end

  describe "when signed in" do
    before(:each) do
      @user = Factory(:user)
      visit signin_path
      fill_in 'User name', :with => @user.user_name
      click_button
    end

    it "should have a signout link" do
      visit root_path
      response.should have_selector("a", :href => signout_path,
                                         :content => "Sign out")
    end

    it "should have a profile link" do
      visit root_path
      response.should have_selector("a", :href => user_path(@user),
                                         :content => "Profile")
    end
  end
end
