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
            var pid = $tree.data('pid');
            var url = "/articles/"+$tree.data('aid')+"/results?format=js&member_id="+pid+'&criterion_id='+node.id;
            $.get(url, function() {
              draw_charts();
            });
          }
        );
      };
    };
    return { build_tree };
  })();

  if ($tree.length > 0) { 
    results_tree.build_tree($('#results-tree').data('node'));
  };

  // Results Charts

  var $chart = $('#chart');
  var create_chart = function(data){
      var chartData = data.chart_data;
      var chartLabels = data.labels;
      var names = data.names;
      $.jqplot($chart.attr("id"), [chartData], {
          seriesDefaults:{
              renderer:$.jqplot.BarRenderer,
              rendererOptions: {
                  varyBarColor: false
              },
              pointLabels: {show: true}
          },
          series:[{ pointLabels:{ 
              show: true, 
              labels: chartLabels, 
              edgeTolerance:-25, 
              escapeHTML: false
          }}],
          axes: {
              xaxis: {
                  renderer: $.jqplot.CategoryAxisRenderer,
                  show: false,
                  showGridline: false, edgeTolerance:-25, escapeHTML: false,
                  tickOptions: { showGridline: false }
              },
              yaxis: {
                  padMax: 1.2
              }
          },
          grid: {
              drawBorder: false,
              shadow: false
          },
          highlighter: {
              show: true,
              sizeAdjust: 7.5,
              tooltipLocation: 'se',
              tooltipContentEditor: function(str, seriesIndex, pointIndex) {
                  var objLabel = names[pointIndex];
                  var val = chartData[pointIndex];
                  return "<span style='font-weight:bold; font-size:14pt; color:#333'>"+val.toPrecision(2)+"</span>";
              }
          },
          cursor: {
              show: false
          }
      });
      $chart.bind('jqplotDataClick', function (ev, seriesIndex, pointIndex, data) {
          $('#point-info').html('series: '+ names[pointIndex]+', value: '+data[1].toPrecision(3));
      });
  };

  var $detail_chart = $('#detail-chart');
  var create_stacked_chart = function(data){
      var chartData = data.chart_data;
      var tickLabels = data.tick_labels;
      var seriesNames = data.series_names;
      var labels = seriesNames.map(function(s){ return {label: s}})

      $.jqplot($detail_chart.attr("id"), chartData, {
          stackSeries: true,
          seriesDefaults:{
              renderer:$.jqplot.BarRenderer,
              rendererOptions: {
                  barMargin: 30
              },
              pointLabels: { show: false }
          },
          axes: {
              xaxis: {
                  renderer: $.jqplot.CategoryAxisRenderer,
                  ticks: tickLabels,
                  tickOptions: { showGridline: false }
              },
              yaxis: {
                  min: 0, padMin: 0
              }
          },
          highlighter: {
              show: true,
              sizeAdjust: 15,
              tooltipLocation: 'n',
              tooltipContentEditor: function(str, seriesIndex, pointIndex) {
                  var objLabel = seriesNames[seriesIndex];
                  var val = chartData[seriesIndex][pointIndex];
                  return "<em>"+objLabel+"</em>: <strong>"+val.toPrecision(2)+"</strong>";
              }
          },
          cursor: {
              show: false
          },
          grid: {
              drawBorder: false,
              shadow: false
          },
          series: labels,
          legend: {
            show: true,
            location: 'e',
            placement: 'outside'
          } 
      });
   
      $detail_chart.bind('jqplotDataClick', 
          function (ev, seriesIndex, pointIndex, data) {
              $('#info2').tooltip({title:seriesIndex+' point: '+pointIndex+', data: '+data});
          }
      );
  };

  function draw_charts() {
    if ($("#chart").length > 0) { 
        $.jqplot.config.enablePlugins = true;
        create_chart($("#chart").data("chart"));
    };
    if ($("#detail-chart").length > 0) { 
        $.jqplot.config.enablePlugins = true;
        create_stacked_chart($("#detail-chart").data("chart"));
    };
  }
  draw_charts();
}); 