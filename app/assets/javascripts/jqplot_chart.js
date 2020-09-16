$(document).on("ready turbolinks:load", function() {
  var $chart = $('#chart');
  $.jqplot.config.enablePlugins = true;
  var data = $chart.data("chart");
  var chartLabels = $chart.data("labels");
  var names = $chart.data("names");
  $.jqplot('chart', [data], {
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
              var val = data[pointIndex];
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