class Track < ActiveRecord::Base
  belongs_to :user
  has_many :vote_relations
  validates :user, presence: true
  validates :title, presence: true
  validates :author, presence: true
  validates :url, format: URI::regexp(%w(http https))
end