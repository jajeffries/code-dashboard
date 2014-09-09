class Dashing.Playstore extends Dashing.Widget
  ready: ->
    @onData(this)
 
  onData: (data) ->
    widget = $(@node)
    widget.find('.name').hide() if !@title
    