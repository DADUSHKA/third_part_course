class CreateAwards < ActiveRecord::Migration[5.2]
  def change
    create_table :awards do |t|
      t.belongs_to :question, foreign_key: { to_table: :questions }
      t.belongs_to :user, foreign_key: { to_table: :users }
      t.string :name

      t.timestamps
    end
  end
end
