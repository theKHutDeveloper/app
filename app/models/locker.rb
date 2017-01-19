class Locker < ApplicationRecord
	has_many :users

	accepts_nested_attributes_for :users
	
	scope :available, -> { where(status: "Free") }
	scope :complete, -> {order("locker_id DESC")}

	validates :locker_id, presence: true
	validates :floor, presence: true
	validates :size, presence: true
	validates :location, presence: true

end
