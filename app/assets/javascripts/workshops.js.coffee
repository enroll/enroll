sendPaymentSettingsToStripeAndSubmit = ->
  $form = $(this)
  $form.find('.btn-primary').prop('disabled', true)

  Stripe.bankAccount.createToken({
    country: 'US',
    routingNumber: $('#user_routing_number').val(),
    accountNumber: $('#user_account_number').val(),
  }, stripeResponseHandler)

  return false

stripeResponseHandler = (status, response) ->
  $form = $('.edit_payment_settings')

  if (response.error)
    $('.alert').remove()

    $outerDiv = $('<div class="alert alert-dismissable alert-danger">')
    $outerDiv.text(response.error.message + ".")
    $outerDiv.prepend($('<strong>Whoops! </strong>'))
    $outerDiv.hide()
    $('header.navbar').after($outerDiv)
    $('.alert').fadeIn()

    $form.find('.btn-primary').prop('disabled', false)
  else
    $("#user_stripe_bank_account_token").val(response.id)
    $form[0].submit()

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

  $("form.disable-submit-on-return input").keydown (e) ->
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

  $('.edit_payment_settings').on 'submit', sendPaymentSettingsToStripeAndSubmit

  Stripe.setPublishableKey('pk_test_vSOC9sUGEcBMh7kdQ5sjcsdM');

$(document).on('ready page:load', ready)
