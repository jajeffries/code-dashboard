require 'TrelloCycleTime'

HMV_BOARD_ID = '5aJf2ZMz'
ACCESS_TOKEN = ENV['TRELLO_TOKEN']



trello_cycle_time = AgileTrello::TrelloCycleTime.new(
	public_key: 'e185a8128064891a8961802a3d86b08e',
	access_token: ACCESS_TOKEN
)

SCHEDULER.every '12h', :first_in => 0 do
  	average_cycle_time = trello_cycle_time.get(
		board_id: HMV_BOARD_ID,
		start_list: 'In Progress',
		end_list: 'Ready for Release'
	)
  	send_event('hmv_cycle_time', { text: average_cycle_time })
  	average_cycle_time_dev = trello_cycle_time.get(
		board_id: HMV_BOARD_ID,
		start_list: 'In Progress',
		end_list: 'Ready for Test'
	)
  	send_event('hmv_cycle_time_dev', { text: average_cycle_time_dev })
end
