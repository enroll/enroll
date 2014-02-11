class window.CoverImageUploader extends Spine.Controller
  events:
    'change input#course_cover_image_image': 'uploadAction'

  constructor: ->
    super

    @setAdminImage(@currentImage)

  uploadAction: (ev) ->
    ev.preventDefault()

    $form = @$el.parents('form:first')
    methodInput = $form.find('input[name=_method]')
    methodInput.detach()

    # $form.attr('action', @imagesPath)
    # $form.submit()

    $form.ajaxSubmit({
      url: @imagesPath
      success: @didUpload
    })

    $form.append(methodInput)

  didUpload: (result) =>
    console.log result

    @setAdminImage(result.admin)
    

  setAdminImage: (image) ->
    @$el.css('background-image', "url(#{image})")