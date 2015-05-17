class Dashing.Jbuild extends Dashing.Widget

	ready: ->
		$(@node).find('.jbuild').jenkinsBuildStatus({
			jenkinsUrl : 'http://jenkins.dev',
			projectTitle : @title,
			projectName: @project,
			refreshTimeout : 10000
		});