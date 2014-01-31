describe 'CourseSchedule', ->
  $el = null
  schedule = null

  beforeEach ->
    $el = $(
      '<div>' +
      ' <input id="course_starts_at" />' +
      ' <div class="form-group course_ends_at"><input id="course_ends_at" /></div>' +
      ' <div class="course-schedule"></div>' +
      ' <a class="multi-day" href="#">multi</a>'
      '</div>'
    ).appendTo('body')

    schedule = new CourseSchedule(el: $el, schedules: [])

  afterEach ->
    $el.remove()

  it 'changing starting date prefills ending date', ->
    $el.find('#course_starts_at').val('2014-01-01').trigger('changeDate')
    $el.find('#course_ends_at').val().should.equal('2014-01-01')

  it 'shows schedule after setting only the starting date', ->
    $el.find('#course_starts_at').val('2014-01-01').trigger('changeDate')
    $el.find('.course-schedule .day').length.should.equal(1)

  it 'does not show any schedule by default', ->
    $el.find('.course-schedule .day').length.should.equal(0)

  xit 'automatically sets end date to start date if end date is before start date', ->
    $el.find('#course_ends_at').val('2014-01-10')
    $el.find('#course_starts_at').val('2014-01-15').trigger('changeDate')
    $el.find('#course_ends_at').val().should.equal('2014-01-15')

  describe 'multi day', ->
    it 'hides end date form group by when no dates are set', ->
      $el.find('.form-group.course_ends_at').is(':visible').should.be.false

    it 'hides end date when start date and ending date are the same', ->
      $el.find('#course_starts_at').val('2014-05-05')
      $el.find('#course_ends_at').val('2014-05-05')
      schedule = new CourseSchedule(el: $el, schedules: [])
      $el.find('.form-group.course_ends_at').is(':visible').should.be.false

    it 'does not hide end date when end date is set AND is different from start date', ->
      $el.find('#course_starts_at').val('2014-05-05')
      $el.find('#course_ends_at').val('2014-05-10')
      schedule = new CourseSchedule(el: $el, schedules: [])
      $el.find('.form-group.course_ends_at').is(':visible').should.be.true

    it 'shows end date form group after clicking the link', ->
      $el.find('a.multi-day').trigger('click')
      $el.find('.form-group.course_ends_at').is(':visible').should.be.true