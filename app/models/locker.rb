class Locker < ApplicationRecord
	has_many :users

	scope :available, -> { where(status: "Free") }
	scope :complete, -> {order("no DESC")}
end
