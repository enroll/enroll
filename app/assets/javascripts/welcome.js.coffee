class window.Welcome extends Spine.Controller
  events:
    'click a.sign-in': 'signInAction'
    'submit form': 'submitAction'
    'click a.sign-up': 'signUpAction'
    # 'click div.top-bar': 'resetAction'

  elements:
    'a.sign-in': '$signIn'
    'div.about': '$aboutSection'
    'div.sign-in': '$signInSection'
    'div.sign-up': '$signUpSection'
    'input#user_email': '$emailField'
    'div.spinner': '$spinner'

  constructor: ->
    super
    @hideAllSections()
    @$spinner.hide()
    @$aboutSection.show()
    @$spinner.spin(SPINNER_WELCOME)

    @$('.feature a').magnificPopup({
      type: 'image'
      retina: {
        # ratio: -> window.devicePixelRatio > 1.5 ? 2 : 1
        ratio: 2
        # replaceSrc: (item, ratio) -> item.src.replace(/\.\w+$/, (m) -> console.log m; '@2x' + m )
      }
    })

  signInAction: -> 
    if @$signInSection.is(':visible')
      @hideAllSections()
      @$aboutSection.show()
      @$signIn.removeClass('active')
    else
      @hideAllSections()
      @$signInSection.show()
      @$emailField.focus()
      @$signIn.addClass('active')

  submitAction: (e) ->
    @hideAllSections()
    @$spinner.show().spin(SPINNER_WELCOME)

  signUpAction: ->
    @hideAllSections()
    @$signUpSection.show()

  hideAllSections: ->
    @$aboutSection.hide()
    @$signInSection.hide()
    @$signUpSection.hide()

  resetAction: ->
    @hideAllSections()
    @$aboutSection.show()