(function(){
	this.IntervalTimer = function(options){
		setInterval(options.onInterval, options.timePeriod);
	}
})();