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

finishEditing = (event) ->
  $editable = $(event.target).first().parents(".editable")
  $editable.removeClass "editing"
  $editable.addClass "edit-ready"
  $editableInput = $editable.find(".workshop-input")
  $newText = ""
  if $editableInput.val() == ""
    $newText = $editableInput.attr("placeholder")
  else
    $newText = $editableInput.val()
  $editable.find(".content").text($newText)
  $editable.find("label").text($newText)
  event.stopPropagation()

ready = ->
  $("#input-seats").keyup calculateRevenue
  $("#input-cost").keyup calculateRevenue
  $("#input-seats").blur calculateRevenue
  $("#input-cost").blur calculateRevenue

  $("#input-cost").keyup updateWorkshopCost
  $("#input-cost").blur updateWorkshopCost

  $('.manage-sidebar').affix();

  $(".editable").click ->
    if $(this).hasClass "edit-ready"
      unless $(this).hasClass "workshop-datetime"
        $(this).removeClass "edit-ready"
        $(this).addClass "editing"
      $(".editable").find(".workshop-input").focus()

  $(".glyphicon-ok").click finishEditing

  $('.datepicker').datepicker(
    format: "yyyy-mm-dd"
    todayHighlight: true
    todayBtn: 'linked'
    autoclose: true
  ).on 'changeDate', (ev) ->
    $('#course_course_starts_at').val(ev.date)
    date = new Date(ev.date)
    $('.datepicker-date').text date.toDateString()
    $('.datepicker-time').text date.toLocaleTimeString()

  $("form.disable-submit-on-return").keydown (e) ->
    code = e.keyCode or e.which
    if code is 13
      e.preventDefault()
      false

  $("input.workshop-input").keypress (event) ->
    if event.which is 13
      finishEditing(event)

$(document).ready(ready)
$(document).on('page:load', ready)
