class BoardCycleTimeEvent
	attr_reader :event_name, :start_list, :end_list

	def initialize(parameters)
		@event_name = parameters[:event_name]
		@start_list = parameters[:start_list]
		@end_list = parameters[:end_list]
	end
end