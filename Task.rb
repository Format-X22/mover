TASK_CLASS = Struct.new(:exist, :direction, :price, :step, :date, :activated, :fresh) do

	def set(direction, price, step)
		self.exist = true
		self.direction = direction
		self.price = price
		self.step = step
		self.fresh = true
		self.activated = false
		self.date = Time.now
	end

	def off
		set(nil, nil, nil)
		self.exist = false
	end
end

TASK = TASK_CLASS.new
TASK.off