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

  didPressKey: (e) ->
    if @isActive && e.keyCode == 27
      @cancelAction()

  previewAction: ->
    @isActive = true

    @$previewContent.removeClass('offscreen')
    @$viewport.addClass('offscreen')


    @updateDescription()
    @$previewContent.html(JST['templates/landing_page_preview'](course: @course))
    # $(document.body).addClass('landing-page')

    # @buildPreviewContent()
    # @_buildExitButton()


  buildPreviewContent: ->
    if !@$previewContent
      @$previewContent = $('<div />')
        .addClass('landing-page-preview')
        .addClass('viewport')
        .addClass('preview')
        .addClass('offscreen')
    @$previewContent.html(JST['templates/landing_page_preview'](course: @course))
    @$previewContent

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

    @$previewContent.addClass('offscreen')
    @$viewport.removeClass('offscreen')

    # $(document.body).removeClass('landing-page')
    # @$originalContent.show()

    # @$previewContent.hide()
    # @$exitButton.hide()

    @$previewContainer or= $();