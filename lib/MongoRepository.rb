require 'mongo' 
include Mongo

class MongoRepository
	def initialize(connection_string, database, collection)
		client = MongoClient.from_uri(connection_string)
		db = client[database]
		@collection = db[collection]
	end

	def find(query)
		@collection.find(query).to_a
	end

	def get(id)
		@collection.find({:_id => id}).to_a()[0]
	end
end