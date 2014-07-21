require_relative '../lib/BoardCycleTimeEvent'
require_relative '../lib/BoardCycleTimeEventManager'

HMV_BOARD_ID = '5aJf2ZMz'

hmv_cycle_time = BoardCycleTimeEventManager.new(HMV_BOARD_ID, [
	BoardCycleTimeEvent.new(event_name: 'hmv_cycle_time', start_list: 'In Progress', end_list: 'Ready for Release'),
	BoardCycleTimeEvent.new(event_name: 'hmv_cycle_time_dev', start_list: 'In Progress', end_list: 'Ready for Test')
])

APP_BOARD_ID = 'aC1nO47x'
app_cycle_times = BoardCycleTimeEventManager.new(APP_BOARD_ID, [
	BoardCycleTimeEvent.new(event_name: 'app_cycle_time', start_list: 'In Progress', end_list: 'Ready for Release'),
	BoardCycleTimeEvent.new(event_name: 'app_cycle_time_dev', start_list: 'In Progress', end_list: 'Ready for Test')
])

APACHE_BOARD_ID = 'rix53wyv'
app_cycle_times = BoardCycleTimeEventManager.new(APACHE_BOARD_ID, [
	BoardCycleTimeEvent.new(event_name: 'apache_cycle_time', start_list: 'In Progress', end_list: 'Ready for Release'),
	BoardCycleTimeEvent.new(event_name: 'apache_cycle_time_dev', start_list: 'In Progress', end_list: 'Ready for Test')
])

SCHEDULER.every '12h', :first_in => 0 do
  	hmv_cycle_time.retrieve
  	app_cycle_times.retrieve
end
