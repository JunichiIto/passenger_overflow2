class AddUserIdToQuestions < ActiveRecord::Migration
  def self.up
    add_column :questions, :user_id, :integer
    add_index :questions, [:user_id, :created_at]
  end

  def self.down
    remove_index :questions, [:user_id, :created_at]
    remove_column :questions, :user_id
  end
end
