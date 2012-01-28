class CreateFriendships < ActiveRecord::Migration
  def change
    create_table :friendships do |t|
      t.references :user
      t.references :friend
    end
    add_index :friendships, [:user_id, :friend_id]
  end
end
