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
			$('#scale-label').text(scaleElement.text());
			switch(scale) {
				case 'importance-scale-5': buildSliders(importanceScale, 2, disable); break;
				case 'importance-scale-9': buildSliders(importanceScale, 1, disable); break;
				case 'level-scale-5':      buildSliders(levelScale, 2, disable); break;
				case 'level-scale-9':			 buildSliders(levelScale, 1, disable); break;
				case 'numeric-scale': 		 buildSliders(numericScale, 1, disable); break;
				case 'free-scale':				 buildSliders(freeScale, 0.1, disable); break;
			};
			selectedScale = scale;
		};
	
		var updateMarker = function(val, pairNo, scaleFunction) {
			console.log("UPDAYE: ", val, pairNo, scaleFunction);
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
					var val = $(this).data("value");
					$("#comparison-"+pairNo).attr("value", val);
					updateMarker(val, pairNo, scaleFunction);
				},
				slide: function(_e, ui) {
					var val = ui.value;
					var pairNo = $(this).data("pair");
					updateMarker(val, pairNo, scaleFunction);
				}
			};
		
			$(sliderDivClass).slider(sliderOpts);
		};
		
		return {
			useScale: 		  useScale,
			buildSliders:   buildSliders,
			selectedScale:  selectedScale,
			defaultScale:   defaultScale,
			sliderDivClass: sliderDivClass
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
			$(this).slider("value", $(this).data("value"));
		}
	});
});


