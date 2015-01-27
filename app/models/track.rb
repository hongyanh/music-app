class Track < ActiveRecord::Base
  belongs_to :user
  has_many :vote_relations
  validates :title, presence: true
  validates :author, presence: true
  validates :url, allow_blank: true, format: URI::regexp(%w(http https))
end