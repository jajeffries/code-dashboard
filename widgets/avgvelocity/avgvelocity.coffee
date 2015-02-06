class Dashing.Avgvelocity extends Dashing.Widget
      ready: ->
      	numberOfVelocities = @velocities.length
      	@weeks = 4 if not @weeks?
      	@weeks = numberOfVelocities if numberOfVelocities < @weeks  
      	lastxWeeks = @velocities.slice(numberOfVelocities - @weeks, numberOfVelocities)
      	total = 0
      	total += velocity.y for velocity in lastxWeeks
      	multiplier = 100
      	roundedAverage = Math.round( (total/@weeks) * multiplier) / multiplier
      	@set('average', roundedAverage )
      	@set('subtitle', @weeks + " weeks")