class window.ClickableList extends Spine.Controller
  events:
    'click li': 'clickAction'

  clickAction: (ev) ->
    $target = $(ev.currentTarget)
    return if $target.hasClass('header')
    href = $target.find('a').attr('href')
    window.location = href