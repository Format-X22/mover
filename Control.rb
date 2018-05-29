require 'readline'

class Control

	def initialize
		loop do
			control Readline.readline('mover > ', true)
			Thread.pass
		end
	end

	def control(command)
		case command
		when 'exit'
			if STATE.active?
				puts 'Cancel task...'
				cancel_task
			end

			puts 'Exit...'
			STATE.shutdown
			exit

		when /^long|^short/
			puts 'Making task...'
			make_task(command)

		when 'cancel'
			puts 'Cancel task...'
			cancel_task
			puts 'Done!'

		when /^status$|^$/
			print_status

		when 'help'
			print_help

		else
			puts 'Unknown command!'
			print_help
		end
	end

	def make_task(command)
		if STATE.active?
			puts 'Another task is active!'
			return
		end

		data = parse_task(command)

		return unless data

		STATE.direction = data[:direction]
		STATE.price = data[:price]
		STATE.step = data[:step]

		STATE.activate

		puts 'Done!'
	end

	def parse_task(command)
		raw = command.chomp.split(' ')

		data = {
			direction: raw[0]&.to_sym,
			price: raw[1]&.to_f,
			step: raw[2]&.to_f
		}

		if not data[:direction] or not data[:price] or not data[:step]
			puts 'Invalid task data!'
			return nil
		end

		if data[:direction] != :long and data[:direction] != :short
			puts 'Invalid direction!'
			return nil
		end

		if data[:price] == 0.0
			puts 'Invalid price!'
			return nil
		end

		if data[:step] == 0.0
			puts 'Invalid step!'
			return nil
		end

		data
	end

	def cancel_task
		unless STATE.active?
			puts 'Task is not active!'
			return
		end

		STATE.deactivate

		while STATE.processed?
			sleep 1
		end
	end

	def print_status
		puts '***'
		puts 'Status:'

		unless STATE.active?
			puts 'Inactive.'
			puts '***'
			return
		end

		print 'Active, '

		unless STATE.processed?
			print "wait for handle...\n"
			puts '***'
			return
		end

		if STATE.enter?
			print "in position at #{ '%.2f' % STATE.current}"

			if STATE.reenter?
				print ' with reenter'
			end

			print ".\n"

			if STATE.parcel?
				puts 'Position is parcel!'
			end

			puts "Direction is #{STATE.direction}."

		else
			print "wait for get position at #{ '%.2f' % STATE.current}.\n"
		end

		puts '***'

	end

	def print_help
		puts ''
		puts 'Commands:'
		puts "\tlong\t%price%\t%step%\t(example - long 8000 2.5)"
		puts "\tshort\t%price%\t%step%\t(example - short 8000 2.5)"
		puts "\tcancel\t\t\t(cancel task)"
		puts "\tstatus\t\t\t([or just enter key] print verbose status)"
		puts "\texit\t\t\t(exit with cancel task)"
		puts ''
	end

end