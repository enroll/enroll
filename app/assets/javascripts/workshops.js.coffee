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
