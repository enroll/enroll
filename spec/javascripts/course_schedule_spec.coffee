describe 'CourseSchedule', ->
  $el = null

  beforeEach ->
    $el = $(
      '<div>' +
      ' <input id="course_starts_at" />' +
      ' <input id="course_ends_at" />' +
      '</div>'
    ).appendTo('body')

  afterEach ->
    $el.remove()

  it 'changing starting date prefills ending date', ->
    schedule = new CourseSchedule(el: $el, schedules: [])
    $el.find('#course_starts_at').val('2014-01-01').trigger('changeDate')

    $el.find('#course_ends_at').val().should.equal('2014-01-01')