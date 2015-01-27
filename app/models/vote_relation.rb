class VoteRelation < ActiveRecord::Base
  belongs_to :user
  belongs_to :track
  scope :single_vote, ->(user_id, track_id) { where("user_id = ? AND track_id = ?", user_id, track_id) }
end