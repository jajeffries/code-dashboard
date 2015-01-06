class Dashing.Avgvelocity extends Dashing.Widget
      ready: ->
      	numberOfVelocities = @velocities.length
      	lastFourWeeks = @velocities.slice(numberOfVelocities - 4, numberOfVelocities)
      	total = 0
      	total += velocity.y for velocity in lastFourWeeks
      	@set('average', total/4)