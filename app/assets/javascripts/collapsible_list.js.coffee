class window.CollapsibleList extends Spine.Controller
  elements:
    '.target': '$target'
    '.toggle': '$toggle'

  events:
    'click .toggle': 'toggle'

  constructor: ->
    super
    state = localStorage[@id]
    if state == 'visible'
      @show()
    else if state == 'hidden'
      @hide()

    if @el.find('li.active').length > 0
      @show()
    
    

  toggle: (e) ->
    e.preventDefault()

    if @$target.is(':visible')
      @hide()
    else
      @show()

  hide: ->
    @$target.hide()
    @$toggle.text('Show')
    localStorage[@id] = 'hidden'

  show: ->
    @$target.show()
    @$toggle.text('Hide')
    localStorage[@id] = 'visible'