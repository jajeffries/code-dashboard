class Dashing.Jbuild extends Dashing.Widget

	ready: ->
		jenkinsServer =
			app: 'http://jenkins.dev'
			apache :'192.168.0.67:8080'		
		$(@node).find('.jbuild').jenkinsBuildStatus({
			jenkinsUrl : jenkinsServer[@team],
			projectTitle : @title,
			projectName: @project,
			refreshTimeout : 10000
		});
		
