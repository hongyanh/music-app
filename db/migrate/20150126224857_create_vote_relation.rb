class CreateVoteRelation < ActiveRecord::Migration
  def change
    create_table :vote_relations, id: false do |t|
      t.belongs_to :track, index: true
      t.belongs_to :user, index: true
    end
  end
end
