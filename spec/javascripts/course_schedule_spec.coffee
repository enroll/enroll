describe 'CourseSchedule', ->
  $el = null

  beforeEach ->
    $el = $(
      '<div>' +
      ' <input id="course_starts_at" />' +
      ' <input id="course_ends_at" />' +
      ' <div class="course-schedule"></div>' +
      '</div>'
    ).appendTo('body')

  afterEach ->
    $el.remove()

  it 'changing starting date prefills ending date', ->
    schedule = new CourseSchedule(el: $el, schedules: [])
    $el.find('#course_starts_at').val('2014-01-01').trigger('changeDate')

    $el.find('#course_ends_at').val().should.equal('2014-01-01')

  it 'shows schedule after setting only the starting date', ->
    schedule = new CourseSchedule(el: $el, schedules: [])
    $el.find('#course_starts_at').val('2014-01-01').trigger('changeDate')
    $el.find('.course-schedule .day').length.should.equal(1)

  it 'does not show any schedule by default', ->
    schedule = new CourseSchedule(el: $el, schedules: [])
    $el.find('.course-schedule .day').length.should.equal(0)