(function($, undefined){
	"use strict";
	$.widget("beast.flipCell", {
		_options: {
			hiddenClass: 'hidden'
		},
		_create: function(){
			new IntervalTimer({
				timePeriod : this.options.interval,
				onInterval : $.proxy(this._flip, this)
			});
		},
		_flip : function(){
			this.element.flip({
				direction : this.options.direction, 
				onAnimation : $.proxy(this._toggleElements, this)
			});
		},
		_toggleElements : function(){
			var hiddenDivSelector = 'div.' + this._options.hiddenClass,
				shownDivSelector = 'div:not(.' + this._options.hiddenClass + ')',
				hiddenElement = this.element.find(hiddenDivSelector);
			this.element
				.find(shownDivSelector)
					.addClass(this._options.hiddenClass);
			hiddenElement.removeClass(this._options.hiddenClass);
		}
	});
})(jQuery);