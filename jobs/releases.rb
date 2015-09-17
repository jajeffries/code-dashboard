require_relative '../lib/MongoRepository'

board_release_mappings = [
	{'_id' => 'HMV', 'event' => 'HMV-releases'},
	{'_id' => 'Apache', 'event' => 'Apache-releases'},
]

if MONGO_CONN.nil?
	MONGO_CONN = ENV['MONGO_CONN']
end

if MONGO_CONN

	repository = MongoRepository.new(MONGO_CONN, 'production', 'release_tracking')

	SCHEDULER.every '15m', :first_in => 0 do
		board_release_mappings.each do | board |
			
			release_data = repository.get(board['_id'])

			send_event(board['event'], {'releases' => release_data['Releases']})
		end
	end
end