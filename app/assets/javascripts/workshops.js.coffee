updateCourseCalculator = ->
  $minSeats = $('#course_min_seats').val()
  $('.min-seats').text($minSeats)

  $maxSeats = $('#course_max_seats').val()
  $('.max-seats').text($maxSeats)

  $cost = $('#course_price_per_seat_in_cents').val()
  $('.ticket-price').text("$#{parseInt($cost)/100}")

  $minRevenue = parseInt($minSeats) * (parseInt($cost) / 100)
  $maxRevenue = parseInt($maxSeats) * (parseInt($cost) / 100)

  if isNaN $minRevenue
    $(".min-seat-revenue").text "$0"
  else
    $(".min-seat-revenue").text "$#{$minRevenue}"
  if isNaN $maxRevenue
    $(".max-seat-revenue").text "$0"
  else
    $(".max-seat-revenue").text "$#{$maxRevenue}"

sendPaymentSettingsToStripeAndSubmit = ->
  $form = $(this)
  $form.find('.btn-primary').prop('disabled', true)

  Stripe.bankAccount.createToken({
    country: 'US',
    routingNumber: $('#user_routing_number').val(),
    accountNumber: $('#user_account_number').val(),
  }, (status, response) -> 
    $("#user_stripe_bank_account_token").val(response.id)
    $('.edit_payment_settings')[0].submit()
  )

  return false

ready = ->
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
    $('#user_course_name').focus()

  $('#sign-up').on 'hide.bs.collapse', ->
    $('.btn-sign-up').addClass('collapsed')

  $('#log-in').on 'show.bs.collapse', ->
    $('#sign-up.in').collapse('hide')
    $('.btn-sign-up').addClass('collapsed')

  $('#log-in').on 'shown.bs.collapse', ->
    $('#log-in .email').focus()

  $('#course_min_seats').on 'propertychange input', updateCourseCalculator
  $('#course_max_seats').on 'propertychange input', updateCourseCalculator
  $('#course_price_per_seat_in_cents').on 'propertychange input', updateCourseCalculator

  $('#for-fun').click ->
    $cost = $('#course_price_per_seat_in_cents')
    $cost.val(0).hide()
    $('.free-text').remove()
    $cost.parent().append("<strong class='free-text'>FREE</strong>")
    $('#revenue-calculator').hide()

  $('#for-profit').click ->
    $cost = $('#course_price_per_seat_in_cents')
    $cost.val(19900).show()
    $('.free-text').remove()
    $('#revenue-calculator').show()
    updateCourseCalculator()

  $('.edit_payment_settings').on 'submit', sendPaymentSettingsToStripeAndSubmit

  Stripe.setPublishableKey('pk_test_vSOC9sUGEcBMh7kdQ5sjcsdM');

$(document).on('ready page:load', ready)
