class Dashing.Jbuild extends Dashing.Widget

	ready: ->
		$(@node).find('.jbuild').jenkinsBuildStatus({
			jenkinsUrl : 'http://shadaloo.ci.dev',
			projectTitle : @title,
			projectName: @project,
			refreshTimeout : 5000
		});