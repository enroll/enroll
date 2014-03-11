ESCAPE_KEY = 27

class window.LandingPagePreview extends Spine.Controller
  events:
    'click a.preview': 'previewAction'
    'click .color-select .choice': 'didChangeColor'

  elements:
    '#course_description': '$description'

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

    @renderLoading()
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

    @$wrapper.show()
    setTimeout =>
      @$previewContent.removeClass('offscreen')
      @$exitButton.fadeIn(250)
    , 10

    $(document.body).css({overflow: 'hidden'})

    @updatePreview()

  renderLoading: ->
    # Renders template that contains "loading text" to entertain user while we
    # wait for Ajax to finish.
    @$previewContent.html(JST['templates/landing_page_preview'](course: @course))

  updatePreview: ->
    # Load from server at this point
    data = @$el.parents('form:first').find('textarea, input[type=text]').serialize()
    $.post @previewPath, data, (res) =>
      @$previewContent.html(res.preview)

  # Cancelling

  cancelAction: ->
    @isActive = false

    @$previewContent.addClass('offscreen')
    @$exitButton.fadeOut(50)

    $(document.body).css({overflow: 'auto'})

    setTimeout =>
      @$wrapper.hide()
    , 300

  # Changing the color

  didChangeColor: ->
    $form = @$el.parents('form:first')

    $form.ajaxSubmit(dataType: 'json')