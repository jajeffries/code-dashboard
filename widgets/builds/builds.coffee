class Dashing.Builds extends Dashing.Widget

	ready: ->
		$(@node).find('[data-build]').teamCityBuildStatus({
			teamcityUrl : 'http://teamcity.dev',
			projectId : @project,
			refreshTimeout : 10000,
			projectName: @title,
			branch : @branch
		});