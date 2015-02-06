class Dashing.Google extends Dashing.Widget

  ready: ->
    @onData(this)

  onData: (data) ->
    widget = $(@node)
    console.log(data)
    # Handle incoming data
    # You can access the html node of this widget with `@node`
    # Example: $(@node).fadeOut().fadeIn() will make the node flash each time data comes in.