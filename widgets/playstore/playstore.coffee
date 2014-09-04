class Dashing.Playstore extends Dashing.Widget
  ready: ->
    @onData(this)
 
  onData: (data) ->
    widget = $(@node)
    console.log(data)
    last_version = @get('last_version')
    rating = last_version.average_rating
    console.log(rating)
    voters_count = last_version.voters_count
    console.log(voters_count)
    widget.find('.google-rating-value').html( '<div>Last Version Average Rating</div><span id="google-rating-integer-value">' + rating + '</span>')
    widget.find('.google-voters-count').html( '<span id="google-voters-count-value">' + voters_count + '</span> Reviews' )