class CreateVotes < ActiveRecord::Migration
  def self.up
    create_table :votes do |t|
      t.integer :user_id
      t.integer :answer_id

      t.timestamps
    end
    add_index :votes, [:user_id, :created_at]
    add_index :votes, [:answer_id, :created_at]
  end

  def self.down
    drop_table :votes
  end
end
