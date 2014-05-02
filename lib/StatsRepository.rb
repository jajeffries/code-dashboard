require 'mongo'

MONGO_CONN = 'mongodb://dashboard:dashing@ds037657.mongolab.com:37657'

class StatsRepository
	def initialize(stat_type)
		client = Mongo::Client.new MONGO_CONN
		db = client['stats']
		@collection = db[stat_type]
	end

	def get(stat_name)
		@c
	end

	def update(stat_name)

	end
end