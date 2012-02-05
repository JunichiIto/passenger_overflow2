describe "Layout links" do
  describe "when not signed in" do
    it "should have a signin link" do
      visit root_path
      response.should have_selector("a", href: signin_path,
                                         content: "Sign in")
    end

    it "should have an ask question link" do
      visit root_path
      response.should have_selector("a", href: new_question_path,
                                         content: "Ask Question")
    end

    it "should have a questions link" do
      visit root_path
      response.should have_selector("a", href: questions_path,
                                         content: "Questions")
    end

    it "should have a users link" do
      visit root_path
      response.should have_selector("a", href: users_path,
                                         content: "Users")
    end
  end

  describe "when signed in" do
    before do
      @user = Factory :user
      visit signin_path
      fill_in "User name", with: @user.user_name
      click_button
    end

    it "should have a signout link" do
      visit root_path
      response.should have_selector("a", href: signout_path,
                                         content: "Sign out")
    end

    it "should show welcome message" do
      response.should have_selector("p", content: "Welcome back")
    end
  end

  describe "when signed out" do
    before do
      @user = Factory :user
      visit signin_path
      fill_in "User name", with: @user.user_name
      click_button
      visit root_path
      click_link "Sign out"
    end

    it "should have a signin link" do
      visit root_path
      response.should have_selector("a", href: signin_path,
                                         content: "Sign in")
    end

    it "should show byebye message" do
      response.should have_selector "p", content: "Bye"
    end
  end
end
