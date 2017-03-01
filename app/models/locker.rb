class Locker < ApplicationRecord
	has_many :users

	accepts_nested_attributes_for :users
	
	scope :available, -> { where(status: "Free") }
	scope :complete, -> {order("ref DESC")}

	scope :by_floor, lambda { |floors| where(floor: [*floors])}
	scope :by_location, lambda { |locations| where(floor: [*locations])}
	scope :by_size, lambda { |si| where(floor: [*si])}
	scope :by_status, lambda { |statuses| where(floor: [*statuses])}

	validates :ref, presence: true
	validates :floor, presence: true
	validates :size, presence: true
	validates :location, presence: true

	# filterrific(
	# 	default_filter_params: {sorted_by: 'ref'},
	# 	available_filters: [
	# 		:sorted_by,
	# 		#:search_query,
	# 		:by_floor,
	# 		:by_location,
	# 		:by_size,
	# 		:by_status
	# 	]
	# )


end
