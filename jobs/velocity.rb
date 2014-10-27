require_relative '../lib/MongoRepository'

BOARD = [
	{'_id' => 'HMV', 'event' => 'HMV-velocity'},
	{'_id' => 'App', 'event' => 'App-velocity'},
	{'_id' => 'Apache', 'event' => 'Apache-velocity'}
]

MONGO_CONN = ENV['MONGO_CONN']

if MONGO_CONN
	repository = MongoRepository.new(MONGO_CONN, 'production', 'velocity')

	SCHEDULER.every '6h', :first_in => 0 do
		BOARD.each do | board |
			board_data = repository.get(board['_id'])
			points = board_data['velocities'].map do | velocity_data |
				date = DateTime.parse(velocity_data['date'])
				{x: date.to_time.getutc.to_i, y: velocity_data['velocity']}
			end
			send_event(board['event'], {'velocities' => points})
		end
	end
end