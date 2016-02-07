class Concert < ActiveRecord::Base
  validates :artist, :datetime, :venue, :price, presence: true
end
