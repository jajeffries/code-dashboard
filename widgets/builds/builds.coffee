class Dashing.Builds extends Dashing.Widget

	ready: ->
		$(@node).find('.build').teamCityBuildStatus({
			teamcityUrl : 'http://teamcity.dev',
			projectId : @project,
			refreshTimeout : 10000,
			projectName: @title,
			branch : @branch
		});