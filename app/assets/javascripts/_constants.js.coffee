window.SPINNER_DEFAULT =
  lines: 13
  length: 5
  width: 2
  radius: 4
  color: '#444'
  speed: 1
  trail: 20
  shadow: false

window.SPINNER_WELCOME = $.extend(window.SPINNER_WELCOME, SPINNER_DEFAULT, {
  color: '#363227'
  length: 15
  radius: 12
  width: 4
  trail: 25
})

window.SPINNER_SMALL = $.extend(window.SPINNER_SMALL, SPINNER_DEFAULT, {
  radius: 6
  length: 7  
})