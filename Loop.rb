class Loop

	def initialize
		@last_candle_date = 0
		#run TODO
	end

	private

	def run
		loop do
			move if new_candle?
			sleep LOOP_DELAY
		end
	end

	def move
		if TASK.fresh
			set_enter
			TASK.fresh = false
		else
			orders_count = BITMEX.order_list.size

			if BITMEX.position
				TASK.activated = true unless TASK.activated

				if orders_count == 0
					set_take_and_stop
				end
			else
				if orders_count == 0
					TASK.off
				end

				if orders_count == 1
					exec_move
				end
			end
		end
	end

	def set_enter
		BITMEX.make_enter(TASK.direction, TASK.price, BITMEX.deposit_value)
	end

	def set_take_and_stop
		#
	end

	def exec_move
		#
	end

	def new_candle?
		last_date = BITMEX.last_candles.last[:date]

		if last_date > @last_candle_date
			@last_candle_date = last_date
			true
		else
			false
		end
	end

end

Thread.new do
	Loop.new
end