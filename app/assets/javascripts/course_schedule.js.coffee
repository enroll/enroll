template = JST['templates/course_schedule']

DPGlobal = $.fn.datepicker.DPGlobal

class window.CourseSchedule extends Spine.Controller
  elements:
    'input#course_starts_at': '$courseStartField'
    'input#course_ends_at': '$courseEndField'
    'div.form-group.course_ends_at': '$courseEndGroup'
    'div.form-group.multi-day': '$multiDayGroup'
    'div.course-schedule': '$courseSchedule'

  events:
    # 'changeDate input#course_starts_at': 'changeStartDateAction'
    'changeDate input#course_starts_at': 'changeDateAction'
    'changeDate input#course_ends_at': 'changeDateAction'
    'click a.multi-day': 'multiDayAction'

  constructor: ->
    super

    # TODO: Hide only if no schedule was passed
    @$courseSchedule.hide()

    @setupDatepicker()

    # This variable holds schedules by dates, so if you  change date away from
    # 12/25, and then change it back, it will restore the schedule.
    @schedulesByDays = {}

    # Restore the schedule cache from Rails object
    for day in @schedules
      @schedulesByDays[day.identifier] =
        startsAt: day.starts_at
        endsAt: day.ends_at

    @updateDays()

    # Hide ending date by default
    @$courseEndGroup.hide()

  setupDatepicker: ->
    @format = 'yyyy-mm-dd'
    @parsedFormat = DPGlobal.parseFormat(@format)
    options =
      format: @format
      todayHighlight: false
      autoclose: true
      startDate: new Date()

    @$courseStartField.datepicker(options)
    @$courseEndField.datepicker(options)

  parseDate: (date) ->
    DPGlobal.parseDate(date, @parsedFormat, 'en')

  formatDate: (date) ->
    DPGlobal.formatDate(date, @parsedFormat, 'en')

  dateToIdentifier: (date) ->
    month = date.getMonth() + 1
    month = "0#{month}" if month <= 9
    "#{date.getFullYear()}-#{month}-#{date.getDate()}"

  changeDateAction: ->
    if @$courseEndField.val() == ''
      @$courseEndField.val(@$courseStartField.val())

    @updateDays()

  updateDays: ->
    @storeSchedulesByDays()

    startVal = @$courseStartField.val()
    if startVal == ''
      return @$courseSchedule.hide()
    start = @parseDate(startVal)
    end = @parseDate(@$courseEndField.val())

    days = []

    while start <= end
      identifier = @dateToIdentifier(start)
      day = 
        date: start
        identifier: identifier
        label: @formatDate(start)
        
      if @schedulesByDays[identifier]
        schedule = @schedulesByDays[identifier]
        day.startsAt = schedule.startsAt
        day.endsAt = schedule.endsAt

      days.push(day)
              
      newDate = start.setDate(start.getDate() + 1)
      start = new Date(newDate);
    
    @render(days)

  storeSchedulesByDays: ->
    # Caches entered schedules
    @$courseSchedule.find('div.day').each (i, row) =>
      $row = $(row)
      date = $row.find('input.date').val()
      startsAt = $row.find('input.start').val()
      endsAt = $row.find('input.end').val()
      @schedulesByDays[date] = {startsAt: startsAt, endsAt, endsAt}

  render: (days) ->
    if days.length == 0
      @$courseSchedule.hide()
      return
      
    @$courseSchedule.html(template(days: days)).show()
    @$courseSchedule.find('input.start.time-select').timepicker(scrollDefaultTime: '9:00am')
    @$courseSchedule.find('input.end.time-select').timepicker(scrollDefaultTime: '4:00pm')

  # Multi day courses

  multiDayAction: (e) ->
    e.preventDefault()

    @$courseEndGroup.show()
    @$multiDayGroup.hide()