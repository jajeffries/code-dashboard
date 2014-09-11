require 'date'
require 'loggly-ruby-client'

#domain:'allegro',username:'allegrodeploy',password:'AllegroNetworks1'
CONFIGURATION = {
	day_range: 7,
	domain: 'codecomputer',
	username: 'codecomputer',
	password: 'manch3st3r',
	query:'500'
}

class DateErrorsFactory
	def initialize(loggly,configuration)
		@loggly = loggly
		@configuration = configuration
		@dates_range_factory = DatesRangeFactory.new(@configuration[:day_range])
		@epochGenerator = EpochGenerator.new
	end

	def create_points
		errors = @loggly.search(from:"-#{@configuration[:day_range]}d",
								query:[@configuration[:query]])["body"]["events"]              
		dates = @dates_range_factory.create
		points = []
		errors.each do |error|
			date = error["timestamp"].to_s[0..-4].to_i
			date = Time.at(date).to_date.to_time.getutc.to_i
			dates[date] += 1
		end
		dates
	end
end

class EpochGenerator
	def generate_epoch(date)
		return date.to_time.getutc.to_i
	end
end

class DatesRangeFactory
	def initialize(number_of_days)
		@number_of_days = number_of_days
		@epochGenerator = EpochGenerator.new
	end
	def generate_epoch(date)
		return date.to_time.to_i
	end

	def create
		dates = Hash.new
		today = Date.today
		(0..(@number_of_days-1)).each do |offset| 
			epoch = @epochGenerator.generate_epoch(today-offset)
			dates[epoch] = 0
		end
		dates
	end
end

class PointsBuilder
	def initialize(date_errors_factory)
		@date_errors_factory = date_errors_factory
	end

	def build
		dates = @date_errors_factory.create_points
		points = []
		count = 0
		dates.each do |date,error_count|
			points[count] = {x: date, y: error_count}
			count +=1
		end
		points.reverse
	end
end

config = LogglyRubyClient::Config.new(domain:CONFIGURATION[:domain],username:CONFIGURATION[:username],password:CONFIGURATION[:password])
loggly = LogglyRubyClient::API.new(config: config)

epoch_generator = EpochGenerator.new
dates_error_factory = DateErrorsFactory.new(loggly,CONFIGURATION)


SCHEDULER.every '2h', :first_in => 0  do
  points = PointsBuilder.new(dates_error_factory).build
  send_event('loggly', points: points)
end


