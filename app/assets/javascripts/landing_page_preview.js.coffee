ESCAPE_KEY = 27

class window.LandingPagePreview extends Spine.Controller
  events:
    'click a.preview': 'previewAction'
    'click .color-select .choice': 'didChangeColor'

  elements:
    '#course_description': '$description'
    '.actions-spinner': '$spinner'

  constructor: ->
    super
    @isActive = false
    $(document).keyup(@didPressKey.bind(@))

    $(document).ready =>
      # Prepare preview viewport
      @$previewContent = @buildPreviewContent()

      # Prepare the exit button
      @$exitButton = @buildExitButton()

  # Building elements

  buildPreviewContent: ->
    if !@$previewContent
      @$wrapper = $('<div />').addClass('viewport-wrapper')
      $(document.body).append(@$wrapper)

      @$previewContent = $('<div />')
        .addClass('landing-page-preview')
        .addClass('viewport')
        .addClass('preview')
        .addClass('offscreen')

      @$wrapper.append(@$previewContent)

    @$previewContent

  buildExitButton: ->
    if !@$exitButton
      @$exitButton = $(JST['templates/landing_page_exit_button']())
      @$exitButton.click(@cancelAction.bind(@))
      $(document.body).append(@$exitButton)
    @$exitButton.hide()

  # Previewing

  didPressKey: (e) ->
    if @isActive && e.keyCode == ESCAPE_KEY
      @cancelAction()

  previewAction: ->
    @isActive = true

    @updatePreview()

  updatePreview: ->
    # Load from server at this point
    data = @$el.parents('form:first').find('textarea, input[type=text]').serialize()
    @$spinner.spin(SPINNER_XS).show()
    $.post @previewPath, data, (res) =>
      @$spinner.hide()
      @$wrapper.show()
      setTimeout =>
        @$previewContent.removeClass('offscreen')
        @$exitButton.fadeIn(250)
      , 10

      $(document.body).css({overflow: 'hidden'})
      @$previewContent.html(res.preview)

  # Cancelling

  cancelAction: ->
    @isActive = false

    @$previewContent.addClass('offscreen')
    @$exitButton.fadeOut(50)

    setTimeout =>
      @$wrapper.hide()
      $(document.body).css({overflow: 'auto'})
    , 550

  # Changing the color

  didChangeColor: ->
    $form = @$el.parents('form:first')

    $form.ajaxSubmit(dataType: 'json')