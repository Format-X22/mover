DB = Sequel.connect('sqlite://data.db')

begin
	DB.create_table :task do
		primary_key :id
		String      :direction, null: false
		Float       :value,     null: false
		Float       :step,      null: false
		Time        :date,      default: Sequel::CURRENT_TIMESTAMP
		TrueClass   :active,    null: false, default: false
	end
rescue
	puts 'Tasks exists!'
end

TASK = DB[:task]