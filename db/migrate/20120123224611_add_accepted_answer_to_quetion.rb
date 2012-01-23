class AddAcceptedAnswerToQuetion < ActiveRecord::Migration
  def self.up
    add_column :questions, :accepted_answer_id, :integer
  end

  def self.down
    remove_column :questions, :accepted_answer_id
  end
end
