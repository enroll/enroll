class window.CoverImageUploader extends Spine.Controller
  events:
    'change input#course_cover_image_file': 'uploadAction'

  constructor: ->
    super

  uploadAction: (ev) ->
    ev.preventDefault()

    $form = @$el.parents('form:first')
    methodInput = $form.find('input[name=_method]')
    methodInput.detach()

    $form.attr('action', @imagesPath)
    $form.submit()

    # $form.ajaxSubmit({
    #   url: @imagesPath
    # })

    $form.append(methodInput)