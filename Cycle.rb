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

		# TODO
	end

end