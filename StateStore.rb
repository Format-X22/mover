class StateStore
	attr_accessor :direction, :price, :step, :current, :take, :stop

	def initialize
		clear
	end

	def clear
		@is_active = false
		@direction = nil
		@price = 0
		@step = 0
		@current = 0
		@is_enter = false
		@take = 0
		@stop = 0
		@is_reenter = false
		@is_parcel = false
		@is_processed = false
		@is_shutdown = false
	end

	def active?
		@is_active
	end

	def enter?
		@is_enter
	end

	def reenter?
		@is_reenter
	end

	def parcel?
		@is_parcel
	end

	def processed?
		@is_processed
	end

	def shutdown?
		@is_shutdown
	end

	def mark_processed
		@is_processed = false
	end

	def activate
		@is_active = true
	end

	def deactivate
		@is_active = false
	end

	def mark_enter
		@is_enter = true
	end

	def mark_reenter
		@is_reenter = true
	end

	def mark_parcel
		@is_parcel = true
	end

	def shutdown
		@is_shutdown = true
	end

end