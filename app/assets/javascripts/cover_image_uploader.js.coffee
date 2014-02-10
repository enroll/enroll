class window.CoverImageUploader extends Spine.Controller
  events:
    'change input#course_cover_image_file': 'uploadAction'

  constructor: ->
    super

  uploadAction: (ev) ->
    ev.preventDefault()

    $form = @$el.parents('form:first')

    $form.ajaxSubmit({
      url: '/cover_images'
    })