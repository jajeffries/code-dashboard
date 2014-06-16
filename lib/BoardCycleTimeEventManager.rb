class BoardCycleTimeEventManager
	def initialize(board_id, cycle_time_events)
		@board_id = board_id
		@cycle_time_events = cycle_time_events
		@trello_cycle_time = AgileTrello::TrelloCycleTime.new(
			public_key: 'e185a8128064891a8961802a3d86b08e',
			access_token: ENV['TRELLO_TOKEN']
		)
	end

	def retrieve
		@cycle_time_events.each do |cycle_time_event|
			average_cycle_time = @trello_cycle_time.get(
				board_id: @board_id,
				start_list: cycle_time_event.start_list,
				end_list: cycle_time_event.end_list
			)
  			send_event(cycle_time_event.event_name, { text: average_cycle_time })
		end
	end
end