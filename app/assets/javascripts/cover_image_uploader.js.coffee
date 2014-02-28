class window.CoverImageUploader extends Spine.Controller
  READY = 'ready'
  UPLOADING = 'uploading'
  DRAGGING = 'dragging'

  events:
    'change input#course_cover_image_image': 'uploadAction'
    'click .save-dragging': 'saveAction'
    'click a.delete-button': 'deleteAction'

  elements:
    '.spinner': '$spinner'
    '.default-buttons': '$defaultButtons'
    '.dragging-buttons': '$draggingButtons'
    '#course_cover_image_offset_admin_px': '$offsetInput'
    'a.delete-button': '$deleteButton'

  constructor: ->
    super

    @setAdminImage(@currentImage)
    @setOffset(@currentOffset)

    @on 'state:change', ->
      if @state == READY
        @$defaultButtons.show()
      else
        @$defaultButtons.hide()

      if @state == UPLOADING
        @$spinner.spin(SPINNER_WELCOME).show()
      else
        @$spinner.hide()

      if @state == DRAGGING
        @$draggingButtons.show()
        @$el.addClass('dragging')
        @$el.data('draggingDisabled', false);
        @$el.backgroundDraggable({axis: 'y', bound: true})
      else
        @$draggingButtons.hide()
        @$el.removeClass('dragging')

    @on 'adminImageId:change', ->
      if @adminImageId
        @$deleteButton.show()
      else
        @$deleteButton.hide()
    @trigger('adminImageId:change')

      
    @state = READY
    @trigger('state:change')
    

  uploadAction: (ev) ->
    ev.preventDefault()

    @setAdminImage(@defaultImage)

    @state = UPLOADING
    @trigger('state:change')

    $form = @$el.parents('form:first')
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

    pos = @$el.css('background-position').match(/(-?\d+).*?\s(-?\d+)/) || []
    top = parseInt(pos[2])

    data = "cover_image[offset_admin_px]=#{top}"
    path = @updatePath.replace(':id', @adminImageId)

    $.ajax({url: path, type: 'PUT', data: data})

    @state = READY
    @trigger('state:change')
    @$el.data('draggingDisabled', true)

  setAdminImage: (image) ->
    return unless image
    @adminImagePath = image
    @$el.css('background-image', "url(#{image})")
    @$el.css('background-position', '0 0')
    @$el.trigger('backgroundImageChanged')

  setOffset: (offset) ->
    return unless offset
    @$el.css('background-position', "0 #{offset}px")

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