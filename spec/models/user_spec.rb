require 'spec_helper'

describe User do
  before(:each) do
    @attr = { :user_name => "junichiito" }
  end

  it "should create a new instance given valid attributes" do
    User.create!(@attr)
  end

  it "should require a name" do
    no_user_name_user = User.new
    no_user_name_user.should_not be_valid
  end
end
