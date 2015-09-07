require_relative '../lib/MongoRepository'

BOARD = [
	{'_id' => 'HMV', 'event' => 'HMV-releases'}
]

MONGO_CONN = ENV['MONGO_CONN']

if MONGO_CONN

	repository = MongoRepository.new(MONGO_CONN, 'production', 'release_tracking')

	SCHEDULER.every '1m', :first_in => 0 do
		BOARD.each do | board |
			
			release_data = repository.get(board['_id'])

			send_event(board['event'], {'releases' => release_data['Releases']})
		end
	end
end