class window.LogoUploader extends Spine.Controller
  events:
    'click a.delete': 'deleteAction'

  elements:
    'a.delete': '$deleteButton'

  constructor: ->
    super
    @$form = $(@form)
    @$field = $(@field)

    @$field.change(@uploadAction)
    @$wrapper = @$field.parent()
    @$spinner = $('<div />')
    @$wrapper.append(@$spinner)
    @$preview = $('<img />')
    @$wrapper.append(@$preview)

    @update()

  update: ->
    if @isUploading
      @$spinner.spin(SPINNER_SMALL).show()
    else
      @$spinner.stop().hide()

    # Preview visibility
    if @isImageUploaded()
      src = @object[@previewAttribute]
      @$preview.attr('src', src).show()
    else
      @$preview.hide()

    # Field visibility
    if @isUploading
      @$field.hide()
    else if @isImageUploaded()
      @$field.hide()
    else
      @$field.show()

    # Delete button
    if @isImageUploaded()
      @$deleteButton.show()
    else
      @$deleteButton.hide()
    
    

  uploadAction: (e) =>
    e.preventDefault()

    @isUploading = true
    @update()

    @$form.ajaxSubmit({
      dataType: 'json'
      success: @didUpload
      error: @didFail
    })

  didUpload: (res) =>
    @object = res
    @isUploading = false
    @update()

    # Reset the upload field to prevent
    # uploading twice
    @$field.replaceWith(@$field = @$field.clone(true))
    @$field.change(@uploadAction)

  didFail: =>
    @isUploading = false
    @update()
    alert 'Upload failed!'

  isImageUploaded: ->
    @object && @object[@previewAttribute]

  deleteAction: (e) ->
    e.preventDefault()
    @object = null
    @update()