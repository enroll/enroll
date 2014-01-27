class window.Welcome extends Spine.Controller
  events:
    'click a.sign-in': 'signInAction'

  elements:
    'a.sign-in': '$signIn'
    'div.about': '$aboutSection'
    'div.sign-in': '$signInSection'
    'input#user_email': '$emailField'

  signInAction: -> 
    @$signIn.toggleClass('active')
    @$aboutSection.toggleClass('hidden')
    @$signInSection.toggleClass('hidden')

    @$emailField.focus()