class window.Welcome extends Spine.Controller
  events:
    'click a.sign-in': 'signInAction'
    'submit form': 'submitAction'

  elements:
    'a.sign-in': '$signIn'
    'div.about': '$aboutSection'
    'div.sign-in': '$signInSection'
    'input#user_email': '$emailField'
    'div.spinner': '$spinner'

  constructor: ->
    super
    @$spinner.spin(SPINNER_WELCOME)

  signInAction: -> 
    @$signIn.toggleClass('active')
    @$aboutSection.toggleClass('hidden')
    @$signInSection.toggleClass('hidden')

    @$emailField.focus()

  submitAction: (e) ->
    @$signInSection.hide()
    @$spinner.removeClass('hidden').spin(SPINNER_WELCOME)