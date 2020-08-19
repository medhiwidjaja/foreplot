function build_tree(root_id) {
  $.getJSON( '/criteria/'+root_id+"/tree.json?p="+$('#criteria-tree').data('pid'),
    function(data) {
      $('#criteria-tree').tree({
        data: [data],
        autoOpen: true,
        dragAndDrop: true,
        selectable: true,
        onCreateLi: function(node, $li, is_selected) {
          if (node.children.length == 0) {
            $li.find('.jqtree-title').before('<i class="icon-leaf"></i> ');
          };
          if (node.weights_incomplete) {
            $li.attr('data-incomplete', true)
            $li.find('.jqtree-title').addClass('incomplete');
          };
          if (node.parent.parent) {
            $li.find('.jqtree-title').after('<i class="icon-reorder pull-right handle"></i>');
          };
          $li.attr("id", node.id);
          $li.attr("data-id", node.id);
        },
        onIsMoveHandle: function($element) {
          return ($element.is('.handle'));
        },
        onCanMove: function(moved_node) {
          if (! moved_node.parent.parent) {
            return false;  // can't move root node
          }
          else {
            return true;
          }
        },
        onCanMoveTo: function(moved_node, target_node, position) {
          if (!target_node.parent.parent) {
            if (position == 'inside')
              return true;  
            else
              return false;   // can't move to root node
          }
          else {
            return true;
          }
        }
      });
      $('.handle').hide();
    });	
  if($('#criteria-tree').data('allowClick')) {
    $('#criteria-tree').on(
    'tree.click',
    function(event) {
      var node = event.node;
      $("#add-criterion").show();
      $("a#add-sub").attr("href", "/criteria/"+node.id+"/new");
      $("a#summary").attr("href", "/criteria/"+node.id+"/aggregate_summary");
      $("a#detail").attr("href", "/criteria/"+node.id+"/aggregate_detail");
      var part = $("li.participant.active").attr("id");
      var url;
      if (part == "summary") {
        url = "/criteria/"+node.id+"/aggregate_summary";
      } 
      else if (part == "detail") {
        url = "/criteria/"+node.id+"/aggregate_detail";
      } 
      else {
        url = "/criteria/"+node.id+"?format=js";
      };
      $.get(url);
    });
    $('#criteria-tree').on(
    'tree.move',
    function(event) {
      var moved_node = event.move_info.moved_node,
          target_node = event.move_info.target_node,
          position = event.move_info.position,
          previous_parent = event.move_info.previous_parent;
      $.post("/criteria/"+moved_node.id+"/move",
        {id:moved_node.id, to:target_node.id, position: position, pid: previous_parent.id}  
      );
    });
  };
  $(".edit-button").on("click", function() {
    if (confirm('Moving a criterion to a different branch will erase any existing comparisons related to the originating and the target branch. \n\nProceed?')) {
      $(this).hide();
      $('.handle').show();
      $('.done-button').show();
    };
  });
  $(".done-button").on("click", function() {
    $(this).hide();
    $(".edit-button").show();
    $(".handle").hide();
    build_tree($('#criteria-tree').data('node'));
  });
};

$(document).on("turbolinks:load", function() {
  if ($('#criteria-tree').length > 0) { 
    build_tree($('#criteria-tree').data('node'));
  };
});