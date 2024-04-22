class CreatePosts < ActiveRecord::Migration[6.1]
  def change
    create_table :posts do |t|
      t.string :facility_name, null: false
      t.text :service, null: false
      t.string :address, null: false
      t.float :star, null: false, default: 0.0
      t.boolean :is_draft, null: false, default: false
      t.integer :user_id, null: false
      t.text :comment
      t.timestamps
    end
  end
end
