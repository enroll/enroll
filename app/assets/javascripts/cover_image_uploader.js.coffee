class window.CoverImageUploader extends Spine.Controller
  events:
    'change input#course_cover_image_image': 'uploadAction'

  elements:
    '.spinner': '$spinner'
    '.buttons': '$buttons'

  constructor: ->
    super

    @$spinner.hide()
    @setAdminImage(@currentImage)

  uploadAction: (ev) ->
    ev.preventDefault()

    @setAdminImage(@defaultImage)
    @showSpinner()

    $form = @$el.parents('form:first')
    methodInput = $form.find('input[name=_method]')
    methodInput.detach()

    $form.ajaxSubmit({
      url: @imagesPath
      success: @didUpload
    })

    $form.append(methodInput)

  didUpload: (result) =>
    @hideSpinner()
    @setAdminImage(result.admin)
    

  setAdminImage: (image) ->
    return unless image
    @$el.css('background-image', "url(#{image})")

  showSpinner: ->
    @$buttons.hide()
    @$spinner.spin(SPINNER_WELCOME).show()

  hideSpinner: ->
    @$buttons.show()
    @$spinner.hide()