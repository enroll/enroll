describe 'LandingPagePreview', ->
  $el = $('<div />')

  it 'builds the preview', ->
    preview = new LandingPagePreview(el: $el, course: {name: 'foo'})
    $wrapper = $('.viewport-wrapper')
    $wrapper.length.should.equal(1)
    $wrapper.find('h2').text().should.equal('foo')

  afterEach ->
    $('.viewport-wrapper').remove()