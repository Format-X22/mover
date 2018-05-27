class AbstractStock
	attr_reader :stock_id

	def initialize(stock_id)
		@stock_id = stock_id
		@keys = File.read('keys.txt').split("\n")
	end

	def make_enter(direction, price, amount)
		# abstract
	end

	def make_take(direction, price, amount)
		# abstract
	end

	def make_stop(direction, price, amount)
		# abstract
	end

	def move_enter(price)
		# abstract
	end

	def cancel_enter
		# abstract
	end
	
	def order_list
		# abstract
	end

	def position
		# abstract
	end

	def deposit_value
		# abstract
	end

	protected

	def decode(data)
		ActiveSupport::JSON.decode(data)
	end

end