class window.CoverImageUploader extends Spine.Controller
  READY = 'ready'
  UPLOADING = 'uploading'
  DRAGGING = 'dragging'

  events:
    'change input#course_cover_image_image': 'uploadAction'
    'click .save-dragging': 'saveAction'
    'click a.delete-button': 'deleteAction'
    'click a.reposition-button': 'repositionAction'

  elements:
    '.cover-image': '$coverImage'
    '.spinner': '$spinner'
    '.add-cover-button, .reposition-button, .delete-button': '$defaultButtons'
    '.add-cover-button': '$changeButton'
    '.save-dragging': '$draggingButtons'
    '#course_cover_image_offset_admin_px': '$offsetInput'
    'a.delete-button': '$deleteButton'
    'a.reposition-button': '$repositionButton'

  constructor: ->
    super

    @setAdminImage(@currentImage)
    @setOffset(@currentOffset)

    @on 'state:change', ->
      if @state == READY
        @$defaultButtons.show()

      if @state == UPLOADING
        @$spinner.spin(SPINNER_WELCOME).show()
      else
        @$spinner.hide()

      if @state == DRAGGING
        @$draggingButtons.show()
        @$coverImage.addClass('dragging')
        @$coverImage.data('draggingDisabled', false);
        @$coverImage.backgroundDraggable({axis: 'y', bound: true})
      else
        @$draggingButtons.hide()
        @$coverImage.removeClass('dragging')

    @on 'adminImageId:change', ->
      if @adminImageId
        @$deleteButton.show()
        @$repositionButton.show()
      else
        @$deleteButton.hide()
        @$repositionButton.hide()

      # Change button
      if @adminImageId
        @$changeButton.text('Change')
      else
        @$changeButton.text('Add cover image') 
      

    @state = READY
    @trigger('state:change')
    @trigger('adminImageId:change')
    

  uploadAction: (ev) ->
    ev.preventDefault()

    @setAdminImage(@defaultImage)

    @state = UPLOADING
    @trigger('state:change')

    $form = @$coverImage.parents('form:first')
    methodInput = $form.find('input[name=_method]')
    methodInput.detach()

    $form.ajaxSubmit({
      url: @imagesPath
      success: @didUpload
    })

    $form.append(methodInput)

  didUpload: (result) =>
    @state = DRAGGING
    @trigger('state:change')

    @adminImageId = result.id
    @trigger('adminImageId:change')
    @setAdminImage(result.admin)
    
  saveAction: (e) ->
    e.preventDefault()

    pos = @$coverImage.css('background-position').match(/(-?\d+).*?\s(-?\d+)/) || []
    top = parseInt(pos[2])

    data = "cover_image[offset_admin_px]=#{top}"
    path = @updatePath.replace(':id', @adminImageId)

    $.ajax({url: path, type: 'PUT', data: data})

    @state = READY
    @trigger('state:change')
    @$coverImage.data('draggingDisabled', true)

  setAdminImage: (image) ->
    return unless image
    @adminImagePath = image
    @$coverImage.css('background-image', "url(#{image})")
    @$coverImage.css('background-position', '0 0')
    @$coverImage.trigger('backgroundImageChanged')

  setOffset: (offset) ->
    return unless offset
    @$coverImage.css('background-position', "0 #{offset}px")

  hideSpinner: ->
    @$defaultButtons.show()
    @$spinner.hide()

  # Deleting

  deleteAction: ->
    path = @updatePath.replace(':id', @adminImageId)
    $.ajax({url: path, type: 'DELETE'})

    @adminImageId = null
    @adminImagePath = null
    @trigger('adminImageId:change')
    @setAdminImage(@defaultImage)

  repositionAction: ->
    @state = DRAGGING
    @trigger('state:change')