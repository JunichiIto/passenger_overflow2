class AddUserNameUniquenessIndex < ActiveRecord::Migration
  def self.up
    add_index :users, :user_name, :unique => true
  end

  def self.down
    remove_index :users, :user_name
  end
end
