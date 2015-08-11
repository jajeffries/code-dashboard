class Dashing.Jbuild extends Dashing.Widget

	ready: ->
		jenkinsServer =
			app: 'http://shadaloo.ci.dev'
			apache :'http://192.168.0.67:8080'		
		$(@node).find('.jbuild').jenkinsBuildStatus({
			jenkinsUrl : jenkinsServer[@team],
			projectName : @title,
			projectId: @project,
			refreshTimeout : 10000
		});
		
