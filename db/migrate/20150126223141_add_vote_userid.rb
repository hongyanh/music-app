class AddVoteUserid < ActiveRecord::Migration
  def change
    change_table :tracks do |t|
      t.belongs_to :user, index: true
      t.integer :votes, default: 0
    end
  end
end
