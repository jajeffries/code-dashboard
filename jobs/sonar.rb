require 'net/http'
require 'json'
require 'openssl'
require 'uri'

def set_trend(trend, metric)


end


PROJECT = [
	{'_id' => 'OdinsRavens', 'project-id' => 'ChesterZoo:Website'},
	{'_id' => 'FOXHOUND', 'project-id' => 'Amnesty:Website'},
	{'_id' => 'OdinsRavens', 'project-id' => 'DWF:Website'},
	{'_id' => 'OdinsRavens', 'project-id' => 'Oxfam:Web'}
]

config_path = File.expand_path(File.join(File.dirname(__FILE__), "sonar.cfg"))

start_date = "2015-09-01T00:00:00+0100"

# Configuration
	configuration = Hash[File.read(config_path).scan(/(\S+)\s*=\s*"([^"]+)/)]
		server = "#{configuration['server']}".strip
		id = "#{configuration['id']}".strip
		metrics = "#{configuration['metrics']}".strip
		samples = "#{configuration['samples']}".strip.to_i
		months = "#{configuration['months']}".strip.to_i
		interval = "#{configuration['interval']}".strip

if id.empty?
    abort("MISSING widget id configuration!")
end
if interval.empty?
    abort("MISSING interval configuration!")
end
if server.empty?
    abort("MISSING server configuration!")
end

if metrics.empty?
    abort("MISSING metrics configuration!")
end

SCHEDULER.every '6h', :first_in => 0 do |job|
	PROJECT.each do | project |
		key = project['project-id']
  	source = "http://sonarqube.dev/api/timemachine?resource=#{key}&metrics=#{metrics}&fromDateTime=#{start_date}"
		puts source
		resp = Net::HTTP.get_response(URI.parse(source))
  	data = resp.body
  	result = JSON.parse(data)

  	cells = result[0]["cells"]

		data = []
#metrics = "line_coverage,tests,function_complexity,duplicated_blocks,coverage"

		METRICLIST = [
			{'name'=> "Number of Tests", 'value' => 0, 'previous_value' => 0, 'trend' => "none", 'type' => "positive"},
			{'name' => "Test Coverage %", 'value' => 0, 'previous_value' => 0, 'trend' => "none", 'type' => "positive"},
			{'name' => "Number of Duplicated Blocks", 'value' => 0, 'previous_value' => 0, 'trend' => "none", 'type' => "negative"},
			{'name' => "Number Of Lines", 'value' => 0, 'previous_value' => 0, 'trend' => "none", 'type' => "neutral"},
			{'name' => "Tech Debt", 'value' => 0, 'previous_value' => 0, 'trend' => "none", 'type' => "negative"},
			{'name' => "Issues", 'value' => 0, 'previous_value' => 0, 'trend' => "none", 'type' => "negative"}
		]
#[{"name"=>"Bob"}, {"age"=>"30"}][1]["age"] = 31

				date = ""

				#This iterates through the dates
				dateIndex = 0
		cells.each do |x|

				index = 0
				metricData = x["v"]
			METRICLIST.each do |metric|
				#Set current values
				metric['value'] = metricData[index]
				#Check current vs previous
				if metric['value'] != nil

					if (metric['value'] > metric['previous_value'] && metric['type'] == "positive")
						metric['trend'] = "increasing"
					end
					if (metric['value'] > metric['previous_value'] && metric['type'] == "negative")
						metric['trend'] = "decreasing"
					end

					if (metric['value'] < metric['previous_value'] && metric['type'] == "positive")
						metric['trend'] = "decreasing"
					end
					if (metric['value'] < metric['previous_value'] && metric['type'] == "negative")
						metric['trend'] = "increasing"
					end

					if (metric['value'] == metric['previous_value'])
						metric['trend'] = "none"
					end

					if (dateIndex == 0)
						metric['previous_value'] = metric['value']
					end

					index = index + 1

				end

		end
		dateIndex = dateIndex + 1


	end

	METRICLIST.each do |metric|
		data << {:label => metric['name'], :value => metric['value'], :initialValue => metric['previous_value'], :trend => metric['trend']}
	end

	puts data

	send_event(project['project-id'], {'items' => data})

	end

end
