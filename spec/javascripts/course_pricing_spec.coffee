describe 'CoursePricing', ->
  $el = null

  beforeEach ->
    $el = $(
      '<div>' +
      ' <input id="course_price_per_seat_in_dollars" />' +
      '</div>'
    ).appendTo(document.body)

  afterEach ->
    $el.remove()

  it 'sets default price upon construction if profit is selected', ->
    pricing = new CoursePricing(el: $el, isFree: false)
    $el.find('#course_price_per_seat_in_dollars').val().should.equal('199')

  it 'does NOT set a default price if there is already price', ->
    $el.find('#course_price_per_seat_in_dollars').val('50')
    pricing = new CoursePricing(el: $el, isFree: false)
    $el.find('#course_price_per_seat_in_dollars').val().should.equal('50')