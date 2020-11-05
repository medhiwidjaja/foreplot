$(document).on('turbolinks:load', function(){
  $('.handle').hide();
  $(".edit-button").on("click", function(event) {
    event.preventDefault();
    $(this).hide();
    $('.handle').show();
    $('.done-button').show();
    $("#sortable").sortable({ 
      update: function(event, ui){  
            $('ul li').each(function(){
            $(this).find('span.badge').html($(this).index()+1);
            $(this).find('input.position').attr('value', $(this).index()+1);
            });
          }
    });
  });
  $(".done-button").on("click", function() {
    $(this).hide();
    $(".edit-button").show();
    $(".handle").hide();
  });
});