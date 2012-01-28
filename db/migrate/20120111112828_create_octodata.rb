class CreateOctodata < ActiveRecord::Migration
  def change
    create_table :octodata do |t|
      t.string :login
      t.integer :data_type
      t.text :content
    end
  end
end
