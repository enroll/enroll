fixture.preload("course_pricing.html.haml")
describe 'CoursePricing', ->
  $el = null

  beforeEach ->
    html = fixture.load("course_pricing.html.haml", true)[0]
    $el = $(html).appendTo(document.body)

  afterEach ->
    $el.remove()

  it 'sets default price upon construction if profit is selected', ->
    pricing = new CoursePricing(el: $el, isFree: false)
    $el.find('#course_price_per_seat_in_dollars').val().should.equal('199')

  it 'does NOT set a default price if there is already price', ->
    $el.find('#course_price_per_seat_in_dollars').val('50')
    pricing = new CoursePricing(el: $el, isFree: false)
    $el.find('#course_price_per_seat_in_dollars').val().should.equal('50')

  it 'highlights the free button in case of free course', ->
    pricing = new CoursePricing(el: $el, isFree: true)
    $el.find('label#for-fun').hasClass('active').should.equal(true)
    $el.find('label#for-profit').hasClass('active').should.equal(false)

  it 'highlights the profit button in case of paid course', ->
    pricing = new CoursePricing(el: $el, isFree: false)
    $el.find('label#for-fun').hasClass('active').should.equal(false)
    $el.find('label#for-profit').hasClass('active').should.equal(true)