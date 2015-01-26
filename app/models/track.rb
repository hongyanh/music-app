class Track < ActiveRecord::Base
  validates :title, presence: true
  validates :author, presence: true
  validates :url, allow_blank: true, :format => URI::regexp(%w(http https))
end