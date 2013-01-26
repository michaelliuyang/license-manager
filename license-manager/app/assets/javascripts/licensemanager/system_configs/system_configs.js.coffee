# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$(document).ready ->
  $("#test_path").click ->
    request = $.post '/system_configs/test_path.text'
      path: $("#system_config_license_path").val()
    request.success (data) ->
      $('#test_path_success p').html(data);
      $('#test_path_success').fadeIn('slow');
      $('#test_path_error').fadeOut('slow');
    request.error (jqXHR, textStatus, errorThrown) ->
      $('#test_path_error p').html(textStatus);
      $('#test_path_error').fadeIn('slow');
      $('#test_path_success').fadeOut('slow');
