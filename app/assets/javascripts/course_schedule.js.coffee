template = JST['templates/course_schedule']

DPGlobal = $.fn.datepicker.DPGlobal

class window.CourseSchedule extends Spine.Controller
  elements:
    'input#course_starts_at': '$courseStartField'
    'input#course_ends_at': '$courseEndField'
    'div.course-schedule': '$courseSchedule'

  events:
    'changeDate input#course_starts_at': 'changeStartDateAction'
    'changeDate input#course_starts_at': 'changeDateAction'
    'changeDate input#course_ends_at': 'changeDateAction'

  constructor: ->
    super

    # TODO: Hide only if no schedule was passed
    @$courseSchedule.hide()


    @setupDatepicker()

    @render(@schedules)

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
    "#{date.getFullYear()}-#{date.getMonth()+1}-#{date.getDate()}"

  # Changing start date

  changeStartDateAction: ->
    if @$courseEndField.val() == ''
      @$courseEndField.val(@$courseStartField.val())

  # Changing any date

  changeDateAction: ->
    @updateDays()

  updateDays: ->
    start = @parseDate(@$courseStartField.val())
    end = @parseDate(@$courseEndField.val())

    days = []

    while start <= end
      days.push
        date: start
        identifier: @dateToIdentifier(start)
        label: @formatDate(start)
      newDate = start.setDate(start.getDate() + 1)
      start = new Date(newDate);

    if days.length == 0
      @$courseSchedule.hide()
      return
    
    @render(days)

  render: (days) ->
    @$courseSchedule.html(template(days: days)).show()
    @$courseSchedule.find('input.start.time-select').timepicker(scrollDefaultTime: '9:00am')
    @$courseSchedule.find('input.end.time-select').timepicker(scrollDefaultTime: '4:00pm')