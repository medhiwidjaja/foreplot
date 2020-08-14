$(document).on("turbolinks:load", function() {
  if ($("ul#sortable").children("li").length==0) {
    $("input:submit[name=commit]").attr("disabled", false);
    $("a.rank-first").attr("disabled", false);
    $("div.rank-first").hide();
  };
  $("li.rank-item").draggable({
    appendTo: ".widget",
    helper: "clone",
    cursor: "move",
    revert: "invalid",
    create: function() {
      $(this).find("strong").before("<i class='icon-reorder'></i>")
    }
  });

  $("#ranks div.thumbnail ul").droppable({
    accept: "li.rank-item",
    activeClass: "ui-state-highlight",
    hoverClass: "ui-state-hover",
    drop: function(event, ui) {
      $(this).find( ".placeholder" ).remove();
      $(ui.draggable).parent("ul.droppable").has("li:only-child").append("<li class='placeholder'>&nbsp;</li>");
      ui.draggable.appendTo(this).draggable();
      $(this).find("input.order").attr("value", $(this).data("rank"));
      if ($("ul#sortable").children("li").length==0) {
        $("input:submit[name=commit]").attr("disabled", false);
        $("div.rank-first").hide();
        $("a.rank-first").attr("disabled", false);
      } else
        $("input:submit[name=commit]").attr("disabled", true);
    }
  });
});