class window.ResourceForm extends Spine.Controller
  elements:
    '.form-section.select': '$selectSelection'
    '.form-section.file-resource': '$fileSection'
    '.form-section.link-resource': '$linkSection'
    '#radio-link input': '$linkRadio'
    '#radio-file input': '$fileRadio'

  events:
    'click #radio-link': 'linkAction'
    'click #radio-file': 'fileAction'
    'submit': 'submitAction'

  constructor: ->
    super

    @$fileSection.hide()
    @$linkSection.hide()

    if @$linkRadio.is(':checked')
      @linkAction()
    else if @$fileRadio.is(':checked')
      @fileAction()

  linkAction: ->
    @$fileSection.hide()
    @$linkSection.show()
    @$el.unbind('submit.transloadit');

  fileAction: ->
    @$linkSection.hide()
    @$fileSection.show()
    @el.attr('enctype', 'multipart/form-data').transloadit({'wait': true})


  submitAction: (ev) ->
    @$('.form-section:hidden').remove()