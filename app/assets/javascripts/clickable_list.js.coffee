class window.ClickableList extends Spine.Controller
  events:
    'click li': 'clickAction'

  clickAction: (ev) ->
    ev.preventDefault()
    href = $(ev.currentTarget).find('a').attr('href')
    window.location = href