class RemoveVotes < ActiveRecord::Migration
  def change
    remove_column :tracks, :votes
  end
end
