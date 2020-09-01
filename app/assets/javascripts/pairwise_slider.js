$(document).on("turbolinks:load", function() {
	var pairwise = (function() {
		var sliderDivClass = "div[class^=pairwise-slider]";
		var defaultScale = 'numeric';

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

		var useScale = function(scale, disable) {
			var labelText;
			if (scale=='importance') { 
				$("#ahp-scale").attr("value", 'importance');
				buildSliders(2, importanceScale, disable);
				labelText = 'Verbal Importance';
			}
			else if (scale=='importance-9') { 
				$("#ahp-scale").attr("value", 'importance-9');
				buildSliders(1, importanceScale, disable);
				labelText = 'Verbal Importance (9 levels)';
			}
			else if (scale=='level') { 
				$("#ahp-scale").attr("value", 'level');
				buildSliders(2, levelScale, disable);
				labelText = 'Verbal Scale';
			}
			else if (scale=='level-9') { 
				$("#ahp-scale").attr("value", 'level-9');
				buildSliders(1, levelScale, disable);
				labelText = 'Verbal Scale (9 levels)';
			}
			else if (scale=='numeric') { 
				$("#ahp-scale").attr("value", 'numeric');
				buildSliders(1, numericScale, disable);
				labelText = 'Numeric (0..9)';
			}
			else if (scale=='free') { 
				$("#ahp-scale").attr("value", 'free');
				buildSliders(0.1, freeScale, disable);
				labelText = 'Free scale (0.0 - 9.0)';
			};
			$('#scale-label').text(labelText);
		};
	
		var updateMarker = function(slider, val, pairNo, scaleFunction) {
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
	
		var buildSliders = function(numberOfSteps, scaleFunction, disable) {
			var sliderOpts = {
				min: -8,
				max: 8,
				step: numberOfSteps,
				range: "zero-based",
				disabled: disable,
				create: function(e, ui) {
					var pairNo = $(this).data("pair");
					var val = $(this).slider("value");
					$("#comparison-"+pairNo).attr("value", val);
					updateMarker($(this), val, pairNo, scaleFunction);
				},
				change: function(e, ui) {
					var pairNo = $(this).data("pair");
					var val = $(this).slider("value");
					$("#comparison-"+pairNo).attr("value", val);
					updateMarker($(this), val, pairNo, scaleFunction);				
				},
				slide: function(e, ui) {
					var val = ui.value;
					var pairNo = $(this).data("pair");
					updateMarker($(this), val, pairNo, scaleFunction);
				}
			};
		

			$(sliderDivClass).slider(sliderOpts);

			$("div[class^=option]").on("click", function() {
				var pairNo = $(this).data("pair");
				$("div[data-pair='"+pairNo+"']").removeClass("option-selected");
				$(this).addClass('option-selected');
				var val = $(".pairwise-slider").filter("[data-pair='"+pairNo+"']").slider("value");
				var newValue = $(this).data("jam")*val > 0 ? val : -val;
				$(".pairwise-slider").filter("[data-pair='"+pairNo+"']").slider("value", newValue);
			});
		};
		
		return {
			importanceScale: importanceScale,
			levelScale: levelScale,
			numericScale: numericScale,
			freeScale: freeScale,
			useScale: useScale,
			buildSliders: buildSliders
		}
	})();

	$(".pairwise-slider").each(function(){
		pairwise.buildSliders(1, pairwise.importanceScale, false);
	});
});


