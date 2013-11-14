class window.LandingPagePreview extends Spine.Controller
  events:
    'click a.preview': 'previewAction'

  elements:
    '#course_description': '$description'

  constructor: ->
    super
    @isActive = false
    @$originalContent = $('.new-course')
    $(document).keyup(@didPressKey.bind(@))

  didPressKey: (e) ->
    if @isActive && e.keyCode == 27
      @cancelAction()

  previewAction: ->
    @isActive = true
    @updateDescription()
    $(document.body).addClass('landing-page')
    @$originalContent.hide()
    @_buildPreviewContent()
    @_buildExitButton()
    @$previewContent.html(JST['templates/landing_page_preview'](course: @course))

  _buildPreviewContent: ->
    if !@$previewContent
      @$previewContent = $('<div />')
      @$originalContent.after(@$previewContent)
    @$previewContent.show()

  _buildExitButton: ->
    if !@$exitButton
      @$exitButton = $(JST['templates/landing_page_exit_button']());
      @$exitButton.click(@cancelAction.bind(@))
      $(document.body).append(@$exitButton)
    @$exitButton.show()

  updateDescription: ->
    # Update description from textarea
    @course.description = markdown.toHTML(@$description.val())

  cancelAction: ->
    @isActive = false
    $(document.body).removeClass('landing-page')
    @$originalContent.show()

    @$previewContent.hide()
    @$exitButton.hide()

    @$previewContainer or= $();