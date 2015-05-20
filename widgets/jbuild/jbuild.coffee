class Dashing.Jbuild extends Dashing.Widget
var jenkinsServer= {
	app: 'http://jenkins.dev',
	apache :''
};
	ready: ->
		$(@node).find('.jbuild').jenkinsBuildStatus({
			jenkinsUrl : jenkinsServer[@team],
			projectTitle : @title,
			projectName: @project,
			refreshTimeout : 10000
		});}
