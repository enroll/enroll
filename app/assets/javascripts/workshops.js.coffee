ready = ->
  $('.manage-sidebar').affix();

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

  $(".course-title-popover").popover(
    trigger: 'focus',
    placement: 'bottom',
    title: "It's free to create a course!",
    content: "You can always change the name of your course later."
  )

$(document).on('page:load', ready)
