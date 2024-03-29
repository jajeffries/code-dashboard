# require_relative '../../trello-cycletime/lib/TrelloCycleTime'
require 'TrelloCycleTime'

class BoardCycleTimeEventManager
	ONE_DAY = 86400
	SIX_WEEKS = ONE_DAY * 42

	def initialize(board_id, cycle_time_events)
		@board_id = board_id
		@cycle_time_events = cycle_time_events
		@trello_cycle_time = AgileTrello::TrelloCycleTime.new(
			public_key: 'e185a8128064891a8961802a3d86b08e',
			access_token: ENV['TRELLO_TOKEN']
		)
	end

	def retrieve
		today = Time.now
		measurement_start_date = today - SIX_WEEKS
		@cycle_time_events.each do |cycle_time_event|
			average_cycle_time = @trello_cycle_time.get(
				board_id: @board_id,
				start_list: cycle_time_event.start_list,
				end_list: cycle_time_event.end_list,
				measurement_start_date: measurement_start_date
			)
			puts "Cycle time retreved: #{@board_id} = #{average_cycle_time.mean}"
  			send_event(cycle_time_event.event_name, { 
  				mean: average_cycle_time.mean, 
  				standard_deviation: average_cycle_time.standard_deviation,
  				start_list: cycle_time_event.start_list,
				end_list: cycle_time_event.end_list
  			})
		end
	end
end