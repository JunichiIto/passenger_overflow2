# -*- coding: utf-8 -*-
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

  it "should reject user_names that are too long" do
    long_name = "a" * 21
    long_name_user = User.new(@attr.merge(:user_name => long_name))
    long_name_user.should_not be_valid
  end

  it "should reject invalid user_names" do
    names = ['UpperCase', 'Include Space', 'にほんご', 'symbol#$%etc']
    names.each do |name|
      invalid_user_name_user = User.new(@attr.merge(:user_name => name))
      invalid_user_name_user.should_not be_valid
    end
  end

  it "should reject duplicate user_names" do
    User.create!(@attr)
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.should_not be_valid
  end
end
