class User < ActiveRecord::Base
  has_many :tracks
  has_many :vote_relations
  validates :email, presence: true, format: /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/
  validates :password, presence: true
end