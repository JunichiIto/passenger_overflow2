require 'spec_helper'

describe "LayoutLinks" do
  it "should have a Home page at '/'" do
    get '/'
    response.should have_selector('title', :content => "Passenger Overview 2")
  end

  it "should have a signup page at '/signup'" do
    get '/signup'
    # Should be more specific
    response.should have_selector('title', :content => "Passenger Overview 2")
  end
end
