SPINNER_SETTINGS =
  lines: 13
  length: 5
  width: 2
  radius: 4
  color: '#444'
  speed: 1
  trail: 20
  shadow: false

class window.ReservationForm extends Spine.Controller
  events:
    'submit': 'submitAction'

  elements:
    '.spinner': '$spinner'
    'input[type=submit]': '$submit'
    '#reservation_stripe_token': '$tokenField'
    '.card-error-message': '$cardErrorMessage'

  constructor: ->
    super

  submitAction: (ev) ->
    ev.preventDefault()

    @startLoading()

    if !@stripeEnabled
      @submit()
      return    

    Stripe.card.createToken @$el, (status, response) =>
      if status != 200
        @showMessage(response.error.message)
        @finishLoading()
        return

      @hideMessage()

      token = response.id
      this.$tokenField.val(token);

      @submit()

  startLoading: ->
    @hideMessage()
    @$spinner.spin(SPINNER_SETTINGS)
    @$submit.prop('disabled', true)

  finishLoading: ->
    @$spinner.spin(false)
    @$submit.prop('disabled', false)    

  # Messages

  showMessage: (message) ->
    @$cardErrorMessage.show().text(message)

  hideMessage: ->
    @$cardErrorMessage.hide().text('')    

  # Submitting

  submit: ->
    @el.get(0).submit()