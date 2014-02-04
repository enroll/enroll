class window.SelectableField extends Spine.Controller
  elements:
    'input': '$input'

  constructor: ->
    super
    $(@$el).mousedown(@select)
    $(@$el).mouseup(@select)
    $(@$el).click(@select)

  select: (ev) =>
    ev.preventDefault()
    @$input.select()