class Dashing.List extends Dashing.Widget
  ready: ->

    metricsRequested = @metrics.split ","
    metricsAvailable = @items

    matchingMetrics = []

    for availableMetric in metricsAvailable
      for requestedMetric in metricsRequested
        rm = requestedMetric.replace /^\s+/g, ""
        if (rm == availableMetric.sonar_id)
          matchingMetrics.push availableMetric

    @set('items', matchingMetrics)

    if @get('unordered')
      $(@node).find('ol').remove()
    else
      $(@node).find('ul').remove()

