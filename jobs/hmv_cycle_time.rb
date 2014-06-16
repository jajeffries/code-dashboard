require 'TrelloCycleTime'
require_relative '../lib/BoardCycleTimeEvent'
require_relative '../lib/BoardCycleTimeEventManager'

HMV_BOARD_ID = '5aJf2ZMz'

hmv_cycle_time = BoardCycleTimeEventManager.new(HMV_BOARD_ID, [
	BoardCycleTimeEvent.new(event_name: 'hmv_cycle_time', start_list: 'In Progress', end_list: 'Ready for Release'),
	BoardCycleTimeEvent.new(event_name: 'hmv_cycle_time_dev', start_list: 'In Progress', end_list: 'Ready for Test')
])

SCHEDULER.every '12h', :first_in => 0 do
  	hmv_cycle_time.retrieve
end
