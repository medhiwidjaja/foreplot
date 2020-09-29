$(document).on("ready turbolinks:load", function() {

  var create_sensitivity_chart = function(element_id, article_id) {

    $.getJSON( '/articles/'+article_id+"/sensitivity_data.json?cid="+$(element_id).data('cid'), (function() {
      var $chart = $(element_id);
      var width = $chart.prev("div.widget-content-title").css("width");
      var w = width.slice( 0, width.length-2 );
      var height = Math.round( +w * 0.8, 1 ) + "px";

      return function(data) {

        var sensitivityChartData = data.sensitivity;
        var chartLabels = data.labels;
        var weight = data.weight;

        $(".weight-value").html(weight.toFixed(3));
        $chart.css("width", width).css("height", height);
        $("#rank-chart").css("width", width).css("height", height);

        var chartData = function(data,x) {
          var y0 = [];
          var y1 = [];
          for (i=0; i < data.length; ++i) {
            y0[i] = data[i][0][1];
            y1[i] = data[i][1][1];
          }
          var series = [[]];
          for (i=0; i < data.length; ++i) {
            series[i] = (y1[i]-y0[i])*x + y0[i];
          }
          return series;
        };

        $.jqplot.config.enablePlugins = true;
        $chart.html("");
        $('#rank-chart').html("");

        $chart.on("jqplotMouseMove", function(ev, gridpos, datapos, neighbor) {
          var w = datapos.xaxis;
          $('#point-info').html('Rank at weight: ' + w.toPrecision(3));
          ranks = chartData(sensitivityChartData, w);
          var seriesData = [];
          for (i=0; i < sensitivityChartData.length; ++i) {
            seriesData[i] = [i+1,ranks[i]];
          }
          plot2.series[0].data = seriesData;
          plot2.redraw();
        });

        $chart.on("jqplotMouseLeave", function(ev, gridpos, datapos, neighbor) {
          var w = weight;
          $('#point-info').html('Rank Chart at weight: ' + w.toPrecision(3));
          ranks = chartData(sensitivityChartData, w);
          var seriesData = [];
          for (i=0; i < sensitivityChartData.length; ++i) {
            seriesData[i] = [i+1,ranks[i]];
          }
          plot2.series[0].data = seriesData;
          plot2.redraw();
        });

        plot1 = $.jqplot($chart.attr("id"), sensitivityChartData, {
          seriesDefaults: {
            pointLabels : {show: false}
          },
          axes: {
            xaxis: { pad: 0 },
            yaxis: { padMin: 0, min: 0.0, max: 1.0 }
          },
          cursor: {
            showVerticalLine: true
          },
          canvasOverlay: {
            show: true,
            objects: [
              {dashedVerticalLine: {
                name: "line3",
                x: weight,
                color: "#E5521D",
                shadow: false
              }}
            ]
          },
          grid: {
              drawBorder: false,
              shadow: false
          },
          legend: {
              show: false,
              location: 'ne',
              placement: 'outside',
              labels: chartLabels
          }
        });

        var maxY = plot1.axes.yaxis.max.toFixed(2);
        var data = chartData(sensitivityChartData, weight);
        var names = chartLabels;

        plot2 = $.jqplot('rank-chart', [data], {
          seriesDefaults:{
            renderer:$.jqplot.BarRenderer,
            rendererOptions: {
              varyBarColor: true
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
              max: maxY,
              min: 0.0
            }
          },
          grid: {
            drawBorder: false,
            shadow: false
          },
          highlighter: {
            show: true,
            sizeAdjust: 7.5,
            tooltipLocation: 'n',
            tooltipContentEditor: function(str, seriesIndex, pointIndex) {
              var objLabel = names[pointIndex];
              var val = data[pointIndex];
              return "<span style='font-weight:bold; font-size:14pt; color:#333'>"+val.toPrecision(2)+"</span>";
            }
          },
          cursor: {
            show: false
          }
        });
      }
    })());
  };

  if ($("#sensitivity-chart").length > 0) { 
    create_sensitivity_chart("#sensitivity-chart", $("#sensitivity-chart").data('article')) 
  };
});