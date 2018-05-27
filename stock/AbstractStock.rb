class AbstractStock
	attr_reader :stock_id

	def initialize(stock_id)
		@stock_id = stock_id
		@keys = File.read('keys.txt').split("\n")
	end
end