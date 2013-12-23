ESCAPE_KEY = 27

class window.LandingPagePreview extends Spine.Controller
  events:
    'click a.preview': 'previewAction'

  elements:
    '#course_description': '$description'

  constructor: ->
    super
    @isActive = false
    $(document).keyup(@didPressKey.bind(@))

    $(document).ready =>
      # Prepare preview viewport
      @$previewContent = @buildPreviewContent()
      $(document.body).append(@$previewContent)

      # Prepare the exit button
      @$exitButton = @buildExitButton()

  # Building elements

  buildPreviewContent: ->
    if !@$previewContent
      @$previewContent = $('<div />')
        .addClass('landing-page-preview')
        .addClass('viewport')
        .addClass('preview')
        .addClass('offscreen')
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

    @$previewContent.removeClass('offscreen')
    @$exitButton.fadeIn(250)

    @updatePreview()

  renderLoading: ->
    # Renders template that contains "loading text" to entertain user while we
    # wait for Ajax to finish.
    @$previewContent.html(JST['templates/landing_page_preview'](course: @course))

  updatePreview: ->
    # Load from server at this point
    data = @$el.parents('form:first').find('textarea, input[type=text]').serialize()
    $.post @previewPath, data, (res) =>
      @$previewContent.html(res)

  # Cancelling

  cancelAction: ->
    @isActive = false

    @$previewContent.addClass('offscreen')
    @$exitButton.fadeOut(50)