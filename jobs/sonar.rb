require 'net/http'
require 'json'
require 'openssl'
require 'uri'
require 'date'

PROJECTS = %w(ChesterZoo:Website Oxfam:Web)
METRICS = (%w(tests coverage duplicated_blocks ncloc sqale_index violations)).join(",")
start_date = DateTime.now - 7


def set_trends_and_values(metric)

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

def retrieve_api_data(metrics, project, start_date)
  key = project
  source = "http://sonarqube.dev/api/timemachine?resource=#{key}&metrics=#{metrics}&fromDateTime=#{start_date}"

  resp = Net::HTTP.get_response(URI.parse(source))


  data = resp.body
  result = JSON.parse(data)

  cells = result[0]['cells']

end

def collate_data_for_board(cells, data, metric_list)
  dateIndex = 0
  cells.each do |x|

    index = 0
    metricData = x["v"]
    metric_list.each do |metric|


      metric[:value] = metricData[index]
      metric[:trend] = set_trends_and_values(metric) if metric[:value] != nil
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
end

SCHEDULER.every '6h', :first_in => 0 do |job|
  PROJECTS.each do |project|

    cells = retrieve_api_data(METRICS, project, start_date)

    data = []

    metric_list = [
        {name: 'Number of Tests', value: 0, previous_value: 0, trend: 'none', type: 'positive'},
        {name: 'Test Coverage %', value: 0, previous_value: 0, trend: 'none', type: 'positive'},
        {name: 'Duplicated Blocks', value: 0, previous_value: 0, trend: 'none', type: 'negative'},
        {name: 'Number of Lines', value: 0, previous_value: 0, trend: 'none', type: 'neutral'},
        {name: 'Tech Debt', value: 0, previous_value: 0, trend: 'none', type: 'negative'},
        {name: 'Issues', value: 0, previous_value: 0, trend: 'none', type: 'negative'}
    ]

    collate_data_for_board(cells, data, metric_list)

    puts data

    send_event(project, {'items' => data})

  end

end
