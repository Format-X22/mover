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

	@task_list = TASK.all

	erb File.read('public/index.html')
end

post '/add' do
	check_auth
	required_params :direction, :start, :step

	direction = params[:direction]
	value = params[:start]
	step = params[:step]

	TASK.insert(direction: direction, value: value, step: step)

	redirect '/'
end

post '/remove' do
	check_auth
	required_params :id

	TASK.where(id: params[:id]).delete

	redirect '/'
end