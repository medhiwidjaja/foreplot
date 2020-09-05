$(document).on("ready turbolinks:load", function() {
	var pairwise = (function() {
		var sliderDivClass = "div[class^=pairwise-slider]";
		var defaultScale = 'numeric';
		var selectedScale;

		var importanceScale = function(val) {
			var scales = ['equally as important',
							'equal to somewhat more important',
							'somewhat more important',
							'somewhat more to more important',
							'more important',
							'more to much more important',
							'much more important',
							'much to extremely more important',
							'extremely more important'];
			return scales[Math.abs(val)];
		};
	
		var levelScale = function(val) {
			var scales = ['equally as good',
							'equal to slightly better',
							'slightly better',
							'slightly to strongly better',
							'strongly better',
							'strongly to very strongly better',
							'very strongly better',
							'very strongly to extremely better',
							'extremely better'];
			return scales[Math.abs(val)];	
		};
	
		var numericScale = function(val) {
			var scales = ['equal',
							'2 X', '3 X', '4 X', '5 X', '6 X', '7 X', '8 X', '9 X' ];
			return scales[Math.abs(val)];
		};
		
		var freeScale = function(val) {
			return (Math.abs(val)+1) + " x";
		};

		var useScale = function(scaleElement, disable) {
			var scale = scaleElement.attr("name");
			var scaleFunction;
			$('#scale-label').text(scaleElement.text());
			switch(scale) {
				case 'importance-scale-5': scaleFunction = importanceScale; buildSliders(scaleFunction, 2, disable); break;
				case 'importance-scale-9': scaleFunction = importanceScale; buildSliders(scaleFunction, 1, disable); break;
				case 'level-scale-5':      scaleFunction = levelScale; buildSliders(scaleFunction, 2, disable); break;
				case 'level-scale-9':			 scaleFunction = levelScale; buildSliders(scaleFunction, 1, disable); break;
				case 'numeric-scale': 		 scaleFunction = numericScale; buildSliders(scaleFunction, 1, disable); break;
				case 'free-scale':				 scaleFunction = freeScale; buildSliders(scaleFunction, 0.1, disable); break;
			};
			selectedScale = scale;
			$(pairwise.sliderDivClass).each(function(){ 
				var pairNo = $(this).data("pair");
				var score = $(this).data("value");
				updateMarker(scoreToSliderValue(score), pairNo, scaleFunction);
			});
		};
	
		var updateMarker = function(val, pairNo, scaleFunction) {
			var activeOption = (val > 0 ? $(".option-right") : $(".option-left"))
				.filter("div[data-pair='"+pairNo+"']");
			$("div[data-pair='"+pairNo+"']").removeClass("option-selected");
			if ( val != 0 ) activeOption.addClass('option-selected');
			
			$("[id^=level]").filter("[data-pair='"+pairNo+"']").html("");
			var sel;
			if (val == 0)
				sel = $("[id^=level]").filter("[data-pair='"+pairNo+"']")
			else if (val > 0)
				sel = $("#level-r-"+pairNo)
			else
				sel = $("#level-l-"+pairNo);
			sel.html("<span class='od'>"+scaleFunction(val)+"</span>");
		};
	
		var buildSliders = function(scaleFunction, step, disable) {
			var sliderOpts = {
				min: -8,
				max: 8,
				step: step,
				range: "zero-based",
				disabled: disable,
				create: function() {
					var pairNo = $(this).data("pair");
					var score = $(this).data("value");
					$("#comparison-"+pairNo).attr("value", score);
					updateMarker(scoreToSliderValue(score), pairNo, scaleFunction);
				},
				slide: function(_e, ui) {
					var val = ui.value;
					var pairNo = $(this).data("pair");
					$("#comparison-"+pairNo).attr("value", sliderValueToScore(val));
					$("#slider-"+pairNo).data("value", sliderValueToScore(val));
					updateMarker(val, pairNo, scaleFunction);
				}
			};		
			$(sliderDivClass).slider(sliderOpts);
		};
		var sliderValueToScore = function(value) {
			return value > 0 ? 1.0/(value+1) : -value+1.0
		};

		var scoreToSliderValue = function(score) {
			return score < 1 ? (1/score)-1 : -score+1;
		};
		
		return {
			useScale: 		  useScale,
			buildSliders:   buildSliders,
			selectedScale:  selectedScale,
			defaultScale:   defaultScale,
			sliderDivClass: sliderDivClass,
			scoreToSliderValue: scoreToSliderValue
		}
	})();

	var defaultScaleElement = $("[name='numeric-scale']");
	pairwise.useScale(defaultScaleElement, false); // the default

	$('.ahp-scale').on('click', function(ev){
		ev.preventDefault();
		disable = $('#pairwise-comparison').data("disable")=='yes';
		pairwise.useScale($(this), disable);
	});
	$(pairwise.sliderDivClass).each(function(){ 
		if ($(this).data("value")!=undefined && $(this).data("value")!=0) { 
			var score = $(this).data("value");
			$(this).slider("value", pairwise.scoreToSliderValue(score));
		}
	});
});


