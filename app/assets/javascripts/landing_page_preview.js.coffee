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
      # Move the whole contents into a wrapper called "viewport"
      $children = $(document.body).children().detach()
      @$viewport = $("<div />").addClass('viewport').addClass('original')
      @$viewport.append($children)
      $(document.body).append(@$viewport)

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
    @$previewContent.html(JST['templates/landing_page_preview'](course: @course))
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
    @$viewport.addClass('offscreen')
    @$exitButton.show()

    @updatePreview()

  updatePreview: ->
    @course.description = markdown.toHTML(@$description.val())
    @$previewContent.html(JST['templates/landing_page_preview'](course: @course))

  # Cancelling

  cancelAction: ->
    @isActive = false

    @$previewContent.addClass('offscreen')
    @$viewport.removeClass('offscreen')
    @$exitButton.hide()