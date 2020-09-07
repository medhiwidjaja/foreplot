$(document).on("ready turbolinks:load", function() {
  var $tree = $('#ratings-tree');
	var criteria_tree = (function() {
    function build_tree(root_id) {
      $.getJSON( '/criteria/'+root_id+"/tree.json?p="+$tree.data('pid'),
        function(data) {
          $tree.tree({
            data: [data],
            autoOpen: true,
            dragAndDrop: false,
            selectable: true,
            onCreateLi: function(node, $li) {
              if (node.children.length == 0) {
                $li.find('.jqtree-title').before('<i class="icon-leaf"></i> ');
              } else {
                $li.find('.jqtree-title').before('<i class="icon-th-list"></i> ').addClass('unselectable-node');
              }
              if (node.ratings_incomplete) {
                $li.find('.jqtree-title').addClass('incomplete');
              };
              $li.attr("data-id", node.id);
            },
            onCanSelectNode: function(node) {
              if (node.children.length == 0) {
                return true; 
              }
              else {
                return false;
              }
            }
          });
        }
      );	
      // if($tree.data('allowClick')) {
      //   $tree.bind(
      //     'tree.click',
      //     function(event) {
      //       var node = event.node;
      //       $("a#summary").attr("href", "/criteria/"+node.id+"/ratings/aggregate_summary");
      //       $("a#detail").attr("href", "/criteria/"+node.id+"/ratings/aggregate_detail");
      //       var part = $("li.participant.active").attr("id");
      //       var url;
      //       if (part == "summary") {
      //         url = "/criteria/"+node.id+"/ratings/aggregate_summary";
      //       } 
      //       else if (part == "detail") {
      //         url = "/criteria/"+node.id+"/ratings/aggregate_detail";
      //       } else {
      //         url = "/criteria/"+node.id+"/ratings?p="+part;
      //       };
      //       $.pjax({
      //         url: url,
      //         container: "[data-pjax-container]"
      //       });
      //     }
      //   );
      // };
    };
    return { build_tree };
  })();

  if ($tree.length > 0) { 
    ratings_tree.build_tree($('#ratings-tree').data('node'));
  };
});
