class Dashing.Builds extends Dashing.Widget

	ready: ->
		$(@node).find('.build').teamCityBuildStatus({
			teamcityUrl : 'http://teamcity.dev',
			projectId : 'project90',
			refreshTimeout : 10000
		});