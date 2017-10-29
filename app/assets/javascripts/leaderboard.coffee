# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
  $('#datepicker').datetimepicker
    format: 'YYYY/MM/DD'

  $('#datepicker').on 'dp.change', ->
    $('#choose-date-form').submit()

  $('#datepicker input').click ->
    $(this).parents('#datepicker').data('DateTimePicker').toggle()
