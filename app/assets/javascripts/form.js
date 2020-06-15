$(document).on("ready pjax:success", function() {
	$(".wysihtml5").each(function(i, elem) {
		$(elem).wysihtml5();
  });
});