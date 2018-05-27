class Loop

	def initialize(stocks)
		init_stocks(stocks)
		sync_candles

		@stock_id = nil
		@stock = nil

		run
	end

	def init_stocks(stocks)
		@stocks = {}

		stocks.each do |stock|
			stock_instance = stock.new
			@stocks[stock.id] = stock_instance
		end
	end

	def sync_candles
		each_stock do
			#
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
		#
	end

	def each_stock(&block)
		@stocks.each do |id, instance|
			@stock_id = id
			@stock = instance

			block.call
		end
	end

end

Thread.new do
	Loop.new([
		Bitmex
	])
end