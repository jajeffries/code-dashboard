require 'net/http'
require 'json'
require 'openssl'
require 'uri'

def setTrend(type, metric)

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

def set_trends_and_values(dateIndex, metric)

  value_is_greater = metric[:value] > metric[:previous_value]
  type_is_positive = metric[:type] == 'positive'
  values_equal = metric[:value] == metric[:previous_value]

  if values_equal
    trend = 'none'
    return trend
  end

  trend_should_be_increasing = value_is_greater && type_is_positive || !value_is_greater && !type_is_positive

  if trend_should_be_increasing
    trend = 'increasing'
  elsif !trend_should_be_increasing
    trend = 'decreasing'
  end

  return trend

end

SCHEDULER.every '6h', :first_in => 0 do |job|
  PROJECT.each do |project|
    key = project['project-id']

    source = "http://sonarqube.dev/api/timemachine?resource=#{key}&metrics=#{metrics}&fromDateTime=#{start_date}"

    resp = Net::HTTP.get_response(URI.parse(source))


    data = resp.body
    result = JSON.parse(data)

    cells = result[0]['cells']

    data = []

    metric_list = [
        {name: 'Number of Tests', value: 0, previous_value: 0, trend: 'none', type: 'positive'},
        {name: 'Test Coverage %', value: 0, previous_value: 0, trend: 'none', type: 'positive'},
        {name: 'Duplicated Blocks', value: 0, previous_value: 0, trend: 'none', type: 'negative'},
        {name: 'Number of Lines', value: 0, previous_value: 0, trend: 'none', type: 'neutral'},
        {name: 'Tech Debt', value: 0, previous_value: 0, trend: 'none', type: 'negative'},
        {name: 'Issues', value: 0, previous_value: 0, trend: 'none', type: 'negative'}
    ]


    dateIndex = 0
    cells.each do |x|

      index = 0
      metricData = x["v"]
      metric_list.each do |metric|


        metric[:value] = metricData[index]
        metric[:trend] = set_trends_and_values(dateIndex, metric) if metric[:value] != nil
        if dateIndex == 0
          metric[:previous_value] = metric[:value]
        end
        index = index + 1
      end

      dateIndex = dateIndex + 1

    end

    metric_list.each do |metric|
      data << {:label => metric[:name], :value => metric[:value], :initialValue => metric[:previous_value], :trend => metric[:trend]}
    end

    puts data

    send_event(project['project-id'], {'items' => data})

  end

end
