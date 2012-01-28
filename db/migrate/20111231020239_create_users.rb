class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :provider
      t.string :uid
      t.string :name, :limit => 80
      t.string :nickname, :limit => 30
      t.string :email
      t.string :location, :limit => 30
      t.string :bio, :limit => 640
      t.string :avatar_url, :limit => 140
      t.string :html_url, :limit => 100
      t.string :token
      
      t.integer :followers_count, :default => 0
      t.integer :friends_count, :default => 0
      t.integer :favourites_count, :default => 0
      t.integer :posts_count, :default => 0
      
      t.datetime :created_at
    end
    add_index :users, [:provider, :uid]
  end
end
