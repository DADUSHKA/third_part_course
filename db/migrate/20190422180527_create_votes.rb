class CreateVotes < ActiveRecord::Migration[5.2]
  def change
    create_table :votes do |t|
      t.integer :choice, null: false, default: 0
      t.belongs_to :voteable, polymorphic: true
      t.belongs_to :user
      t.index([:voteable_type, :voteable_id, :user_id], unique: true)
    end
  end
end
