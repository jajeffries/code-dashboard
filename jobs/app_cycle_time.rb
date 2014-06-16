require 'TrelloCycleTime'
require_relative '../lib/BoardCycleTimeEvent'
require_relative '../lib/BoardCycleTimeEventManager'

APP_BOARD_ID = 'aC1nO47x'
app_cycle_times = BoardCycleTimeEventManager.new(APP_BOARD_ID, [
	BoardCycleTimeEvent.new(event_name: 'app_cycle_time', start_list: 'In Progress', end_list: 'Ready for Release'),
	BoardCycleTimeEvent.new(event_name: 'app_cycle_time_dev', start_list: 'In Progress', end_list: 'Ready for Test')
])

SCHEDULER.every '12h', :first_in => 0 do
  	app_cycle_times.retrieve
end