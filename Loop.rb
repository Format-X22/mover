class Loop

	def initialize(stocks)
		@stocks = {}
		@last_candle_date = {}
		@stock_id = nil
		@stock = nil

		init_stocks(stocks)
		run
	end

	private

	def init_stocks(stocks)
		stocks.each do |stock|
			stock_instance = stock.new
			@stocks[stock.id] = stock_instance
			@last_candle_date[stocks.id] = 0
		end
	end

	def run
		loop do
			each_stock do
				move if new_candle?
			end

			sleep LOOP_DELAY
		end
	end

	def move
		task_list.each do |task|
			#
		end
	end

	def task_list
		#
	end

	def new_candle?
		last_date = @stock.last_candles.last[:date]

		if last_date > @last_candle_date[@stock_id]
			@last_candle_date[@stock_id] = last_date
			true
		else
			false
		end
	end

	def each_stock(&block)
		@stocks.each do |id, instance|
			@stock_id = id
			@stock = instance

			block.call
		end

		@stock_id = nil
		@stock = nil
	end

end

Thread.new do
	Loop.new([
		Bitmex
	])
end