class CreateTracks < ActiveRecord::Migration
  def change
    create_table :tracks do |t|
      t.string :title, null: false
      t.string :author, null: false
      t.string :url, null: false
      t.timestamps
    end
  end
end
