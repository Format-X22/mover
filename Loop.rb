class Loop

	def initialize
		@last_candle_date = 0
		run
	end

	private

	def run
		loop do
			move if new_candle?
			sleep LOOP_DELAY
		end
	end

	def move
		task_list.each do |task|
			#
		end
	end

	def task_list
		TASK.where(active: false)
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