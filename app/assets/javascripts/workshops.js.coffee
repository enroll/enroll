calculateRevenue = ->
  $seats = $("#input-seats").val()
  $cost = $("#input-cost").val()
  $revenue = parseInt($seats) * parseInt($cost)
  if isNaN $revenue
    $("#revenue").text "$0"
  else
    $("#revenue").text "$#{$revenue}"

updateWorkshopCost = ->
  $cost = $("#input-cost").val()
  $(".workshop-cost").text($cost)

ready = ->
  $("#input-seats").keyup calculateRevenue
  $("#input-cost").keyup calculateRevenue
  $("#input-seats").blur calculateRevenue
  $("#input-cost").blur calculateRevenue

  $("#input-cost").keyup updateWorkshopCost
  $("#input-cost").blur updateWorkshopCost

  $('.manage-sidebar').affix();

  $('.datepicker').datepicker(
    format: "yyyy-mm-dd"
    todayHighlight: true
    todayBtn: 'linked'
    autoclose: true
  )

  $("form.disable-submit-on-return").keydown (e) ->
    code = e.keyCode or e.which
    if code is 13
      e.preventDefault()
      false

  $(".course-title-popover").popover(
    trigger: 'focus',
    placement: 'bottom',
    title: "It's free to create a course!",
    content: "You can always change the name of your course later."
  )

  $('#sign-up').on 'show.bs.collapse', ->
    $('#log-in.in').collapse('hide')
    $('.btn-log-in').addClass('collapsed')
    $('.btn-sign-up').removeClass('collapsed')

  $('#sign-up').on 'shown.bs.collapse', ->
    $('#instructor_course_name').focus()

  $('#sign-up').on 'hide.bs.collapse', ->
    $('.btn-sign-up').addClass('collapsed')

  $('#log-in').on 'show.bs.collapse', ->
    $('#sign-up.in').collapse('hide')
    $('.btn-sign-up').addClass('collapsed')

  $('#log-in').on 'shown.bs.collapse', ->
    $('#log-in .email').focus()

$(document).ready(ready)
$(document).on('page:load', ready)
