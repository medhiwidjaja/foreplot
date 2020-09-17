$(document).on("ready turbolinks:load", function() {
  var $chart = $('#chart');
  var create_chart = function() { 
    $.getJSON( '/articles/'+$chart.data("id")+"/results/chart.json?p="+$chart.data('pid'),
    function(data){
      var chartData = data.chart_data;
      var chartLabels = data.labels;
      var names = data.names;
      $.jqplot('chart', [chartData], {
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
              tooltipLocation: 'ne',
              tooltipContentEditor: function(str, seriesIndex, pointIndex) {
                  var objLabel = names[pointIndex];
                  var val = chartData[pointIndex];
                  return "<span style='font-weight:bold; font-size:12pt; color:#333'>"+val.toPrecision(2)+"</span>";
              }
          },
          cursor: {
              show: false
          }
      });
      $('#chart').bind('jqplotDataClick', 
        function (ev, seriesIndex, pointIndex, data) {
            $('#point-info').html('series: '+ names[pointIndex]+', value: '+data[1].toPrecision(3));
        }
      );
    });
  };
  if ($chart.length > 0) { 
    $.jqplot.config.enablePlugins = true;
    create_chart();
  };
});