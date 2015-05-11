class Dashing.Jbuild extends Dashing.Widget

  ready: ->
		$(@node).find('.jbuild').jenkinsBuildStatus({			
			jenkinsUrl : 'http://jenkins.dev',
			projectGroupName : @project,
			refreshTimeout : 5000
		});