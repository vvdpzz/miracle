class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string   :text, :limit => 560
      
      t.integer  :in_reply_to_post_id
      t.integer  :in_reply_to_user_id
      
      t.integer  :user_id, :null => false
      t.string   :name, :limit => 80
      t.string   :nickname, :limit => 30
      t.string   :avatar_url, :limit => 140
      
      t.decimal  :geo_lat, :precision => 10, :scale => 5
      t.decimal  :geo_long, :precision => 10, :scale => 5
      
      t.text     :entities
      
      t.datetime :created_at
      
      t.boolean  :delta, :default => true, :null => false
    end
    add_index :posts, :user_id
  end
end
