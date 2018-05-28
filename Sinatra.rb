helpers do
	def check_auth
		key = File.read('keys.txt').lines.first.chomp

		unless cookies[:auth_key] == key
			halt 404, '404'
		end
	end
end

get '/' do
	check_auth

	erb File.read('public/index.html')
end

post '/add' do
	check_auth
	required_params :direction, :start, :step

	TASK.set(params[:direction], params[:start], params[:step])

	redirect '/'
end

post '/remove' do
	check_auth
	required_params :id

	TASK.off

	if BITMEX.order_list.size == 1
		BITMEX.cancel_enter
	end

	redirect '/'
end