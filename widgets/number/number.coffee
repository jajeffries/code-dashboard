class Dashing.Number extends Dashing.Widget

  @accessor 'current', Dashing.AnimatedValue

  @accessor 'difference', ->
    if @get('last')
      last = @get('last')
      current =@get('current')
      if last != 0
        diff = ((Math.abs(current - last))/current*100).toFixed(2)
        "#{diff}%"
    else
      ""

  @accessor 'arrow', ->
    if @get('last')
      if parseInt(@get('current')) > parseInt(@get('last')) then 'icon-arrow-up' else 'icon-arrow-down'


