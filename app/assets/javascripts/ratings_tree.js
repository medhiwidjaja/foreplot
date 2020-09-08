$(document).on("ready turbolinks:load", function() {
  var $tree = $('#ratings-tree');
	var ratings_tree = (function() {
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
                $li.find('.jqtree-title').addClass('leaf').before('<i class="icon-leaf"></i> ');
              } else {
                $li.find('.jqtree-title').addClass('unselectable-node').before('<i class="icon-th-list"></i> ');
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
      if($tree.data('allowClick')) {
        $tree.bind(
          'tree.click',
          function(event) {
            var node = event.node;
            var part = $tree.data('pid');
            var url = "/criteria/"+node.id+"/ratings?format=js&p="+part;
            $.get(url);
          }
        );
      };
    };
    return { build_tree };
  })();

  if ($tree.length > 0) { 
    ratings_tree.build_tree($('#ratings-tree').data('node'));
  };
});
