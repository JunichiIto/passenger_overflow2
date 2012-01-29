class CreateReputations < ActiveRecord::Migration
  def self.up
    create_table :reputations do |t|
      t.integer :activity_id
      t.string :activity_type
      t.integer :user_id
      t.string :reason
      t.integer :point

      t.timestamps
    end
    add_index :reputations, [:user_id, :created_at]
  end

  def self.down
    drop_table :reputations
  end
end
