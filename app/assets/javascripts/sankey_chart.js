$(document).on("ready turbolinks:load", function() {
  var $tree = $('#viz-tree');
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
            var pid = $tree.data('pid');
            var url = "/articles/"+$tree.data('aid')+"/sankey.json?&member_id="+pid+'&criterion_id='+node.id;
            $("#sankey").html("");
            create_sankey_chart("#sankey", url);
          }
        );
      };
    };
    return { build_tree };
  })();

  if ($tree.length > 0) { 
    results_tree.build_tree($('#viz-tree').data('node'));
  };

  // Sankey chart

  var create_sankey_chart = function(element_id, url) {
    var $chart = $(element_id);
    var margin = {top: 10, right: 1, bottom: 6, left: 1},
      width = $chart.width() - margin.left - margin.right,
      height = $chart.height() - margin.top - margin.bottom;

    var formatNumber = d3.format(",.3f"),
      format = function(d) { return "Weight:" + formatNumber(d); },
      color = d3.scale.category20();

    var svg = d3.select(element_id).append("svg")
      .attr("width", width + margin.left + margin.right)
      .attr("height", height + margin.top + margin.bottom)
      .append("g")
      .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

    var sankey = d3.sankey()
      .nodeWidth(20)
      .nodePadding(20)
      .size([width, height]);

    var path = sankey.link();

    d3.json(url, function(score) {

      var nodeMap = {};
      score.nodes.forEach(function(x) { nodeMap[x.id] = x; });
      score.links = score.links.map(function(x) {
        return {
          source: nodeMap[x.source],
          target: nodeMap[x.target],
          value: x.value == 0 ? 0.00000000000001 : x.value
        };
      });

    sankey
        .nodes(score.nodes)
        .links(score.links)
        .layout(32);

    var node = svg.append("g")
        .attr("class", "container")
        .selectAll(".node")
        .data(score.nodes)
      .enter().append("g")
        .attr("class", "node")
        .attr("transform", function(d) { return "translate(" + d.x + "," + d.y + ")"; })
        .call(d3.behavior.drag()
        .origin(function(d) { return d; })
        .on("dragstart", function() { this.parentNode.appendChild(this); })
        .on("drag", dragmove))
        .on("click",function(d) {
          if (d3.event.defaultPrevented) return;
          zoomIn(d.id);
        });
        

    node.append("rect")
        .attr("height", function(d) { return d.dy; })
        .attr("width", sankey.nodeWidth())
        .style("fill", function(d) { return d.color = color(d.name.replace(/ .*/, "")); })
        .style("stroke", function(d) { return d3.rgb(d.color).darker(2); })
      .append("title")
        .text(function(d) { return d.name + "\n" + format(d.value); });

    node.append("text")
        .attr("x", -6)
        .attr("y", function(d) { return d.dy / 2; })
        .attr("dy", ".35em")
        .attr("text-anchor", "end")
        .attr("transform", null)
        .text(function(d) { return d.name; })
        .filter(function(d) { return d.x < width / 2; })
        .attr("x", 6 + sankey.nodeWidth())
        .attr("text-anchor", "start");

    var link = svg.append("g")
        .attr("class", "container")
        .selectAll(".link")
        .data(score.links)
      .enter().append("path")
        .attr("class", "link")
        .attr("d", path)
        .style("stroke-width", function(d) { return Math.max(1, d.dy); })
        .style("stroke", function(d) { return d3.rgb(d.source.color).darker(2); } )
        .sort(function(a, b) { return b.dy - a.dy; });

    link.append("title")
        .text(function(d) { return d.source.name + " → " + d.target.name + "\n" + format(d.value); });

    d3.select("#sankey svg g")
        .selectAll(".container")
        .sort(function(a, b) { return -1 })      // I know this is cheating.

    function dragmove(d) {
      d3.select(this).attr("transform", "translate(" + d.x + "," + (d.y = Math.max(0, Math.min(height - d.dy, d3.event.y))) + ")");
      sankey.relayout();
      link.attr("d", path);
    };

    function zoomIn(node_id) {
      var idx = node_id.search('-');
      var id = node_id.slice(idx+1, node_id.length);
      if (node_id.slice(0, idx) == 'Criterion') {
        var url = "/articles/"+$tree.data('aid')+"/sankey.json?&member_id="+$tree.data('pid')+'&criterion_id='+id;
        $("#sankey").html("");
        create_sankey_chart("#sankey", url);
      }
    };

    });


  };

  if ($("#sankey").length > 0) { create_sankey_chart("#sankey", $("#sankey").data("url")) };

});
