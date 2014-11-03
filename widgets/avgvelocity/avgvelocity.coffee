class Dashing.Avgvelocity extends Dashing.Widget
      ready: ->
      	numberOfVelocities = @velocities.length
      	lastFourWeeks = @velocities.slice(numberOfVelocities - 5, numberOfVelocities-1)
      	total = 0
      	total += velocity.y for velocity in lastFourWeeks
      	@set('average', total/4)