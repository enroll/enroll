class window.CoverImageUploader extends Spine.Controller
  READY = 'ready'
  UPLOADING = 'uploading'
  DRAGGING = 'dragging'

  events:
    'change input#course_cover_image_image': 'uploadAction'
    'click .save-dragging': 'saveAction'

  elements:
    '.spinner': '$spinner'
    '.default-buttons': '$defaultButtons'
    '.dragging-buttons': '$draggingButtons'

  constructor: ->
    super

    @setAdminImage(@currentImage)

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

      
    @state = DRAGGING
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

    @setAdminImage(result.admin)
    
  saveAction: (e) ->
    e.preventDefault()

    @state = READY
    @trigger('state:change')
    # @$el.data('draggingDisabled', true)


  setAdminImage: (image) ->
    return unless image
    @$el.css('background-image', "url(#{image})")
    @$el.css('background-position', '0 0')
    @$el.trigger('backgroundImageChanged')

  hideSpinner: ->
    @$defaultButtons.show()
    @$spinner.hide()