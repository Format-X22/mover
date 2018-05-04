require 'sinatra'
require 'sinatra/contrib/all'
require 'sequel'

DB = Sequel.connect('sqlite://data.db')
TASK = DB[:task]
TAKE_LONG_MUL = 1.012
TAKE_SHORT_MUL = 0.988
STOP_LONG_MUL = 1.025
STOP_SHORT_MUL = 0.975

begin
	DB.create_table :task do
		primary_key :id
		String :direction, null: false
		Float :value, null: false
		Float :step, null: false
		Time :date, default: Sequel::CURRENT_TIMESTAMP
		TrueClass :active, null: false, default: false
	end
rescue
	puts 'Tasks exists!'
end

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