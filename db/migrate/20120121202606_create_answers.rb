class CreateAnswers < ActiveRecord::Migration
  def self.up
    create_table :answers do |t|
      t.text :content
      t.integer :user_id
      t.integer :question_id

      t.timestamps
    end
    add_index :answers, [:user_id, :created_at]
    add_index :answers, [:question_id, :created_at]
  end

  def self.down
    drop_table :answers
  end
end
