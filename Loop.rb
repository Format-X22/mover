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
				set_take_and_stop
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
		value = BITMEX.deposit_value * MARGIN_MUL - 0.00000001

		BITMEX.make_enter(TASK.direction, TASK.price, value)
	end

	def set_take_and_stop
		position = BITMEX.position
		direction = TASK.direction
		price = position[:price]
		amount = position[:amount]

		if direction == :long
			take = price * TAKE_LONG_MUL
			stop = price * STOP_LONG_MUL
		else
			take = price * TAKE_SHORT_MUL
			stop = price * STOP_SHORT_MUL
		end

		BITMEX.make_take(direction, take, amount)
		BITMEX.make_stop(direction, stop, amount)

		TASK.take = take
		TASK.stop = stop
	end

	def exec_move
		if TASK.direction == :long
			price = TASK.current + TASK.step
		else
			price = TASK.current - TASK.step
		end

		BITMEX.move_enter(price)
		TASK.current = price
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