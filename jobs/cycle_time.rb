require_relative '../lib/MongoRepository'

CYCLE_TIME_CALCULATION_EVENTS = [
	'app_cycle_time',
	'app_cycle_time_dev',
	'hmv_cycle_time',
	'hmv_cycle_time_dev',
	'apache_cycle_time',
	'apache_cycle_time_dev',
	'a_team'
]

MONGO_CONN = ENV['MONGO_CONN']

if MONGO_CONN
	repository = MongoRepository.new(MONGO_CONN, 'production', 'cycle_time')

	SCHEDULER.every '6h', :first_in => 0 do
		CYCLE_TIME_CALCULATION_EVENTS.each do | cycle_time_event |
			cycle_time_event_data = repository.get(cycle_time_event)
			points = cycle_time_event_data['cycle_times'].map do | cycle_time |
				date = DateTime.parse(cycle_time['date'])
				{x: date.to_time.getutc.to_i, y: cycle_time['mean']}
			end
			send_event(cycle_time_event, {'cycleTimes' => points})
		end
	end
end