class CreateTagships < ActiveRecord::Migration
  def change
    create_table :tagships do |t|
      t.references :user
      t.references :tag
    end
    add_index :tagships, [:user_id, :tag_id]
  end
end
