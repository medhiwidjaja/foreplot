$(document).on("ready turbolinks:load", function() {
  var $tree = $('#results-tree');
	var results_tree = (function() {
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
              $li.find('.title').before('<i class="icon-leaf"></i> ');
            } else {
              $li.find('.title').before('<i class="icon-th-list"></i> ');
            }
          }
        });
      });
      if($tree.data('allowClick')) {
        $tree.bind(
          'tree.click',
          function(event) {
            var node = event.node;
            var part = $tree.data('pid');
            var url = "/criteria/"+node.id+"/rank?format=js&p="+part;
            $.get(url);
          }
        );
      };
    };
    return { build_tree };
  })();

  if ($tree.length > 0) { 
    results_tree.build_tree($('#results-tree').data('node'));
  };
}); 