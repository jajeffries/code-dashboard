class Dashing.Appstore extends Dashing.Widget
  ready: ->
    @onData(this)
 
  onData: (data) ->
    widget = $(@node)
    widget.find('.name').hide() if !@title
    widget.find('.review#latest').hide() if !data.last_version