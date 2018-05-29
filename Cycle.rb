class Cycle

	def initialize
		loop do
			iteration
			sleep CYCLE_DELAY
		end
	end

	def iteration
		if STATE.shutdown?
			exit
		end

		if not STATE.active? and STATE.processed?
			mode :cancel
		end

		case mode
		when :init then init
		when :cancel then cancel
		when :move then move
		when :position then position
		else
			raise 'Invalid state'
		end
	end

	def mode(value = nil)
		if value
			STATE.cycle_mode = value
		else
			STATE.cycle_mode
		end
	end

	def init
		return unless STATE.active?

		BITMEX.make_enter(
			STATE.direction,
			STATE.price,
			BITMEX.deposit_value * MARGIN_MUL
		)

		STATE.mark_processed
		
		mode :move
	end

	def cancel
		#
	end

	def move
		#
	end

	def position
		#
	end

end