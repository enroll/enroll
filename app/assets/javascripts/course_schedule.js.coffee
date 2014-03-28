template = JST['templates/course_schedule']

DPGlobal = $.fn.datepicker.DPGlobal

SHORT_FORMAT = 'yyyy/mm/dd'
LONG_FORMAT = 'D, M dd, yyyy'

class window.CourseSchedule extends Spine.Controller
  elements:
    'input#course_starts_at': '$courseStartField'
    'input#course_ends_at': '$courseEndField'
    'div.form-group.course_ends_at': '$courseEndGroup'
    'div.form-group.multi-day': '$multiDayGroup'
    'div.course-schedule': '$courseSchedule'
    'div.campaign-end-notice': '$campaignEndNotice'

  events:
    'changeDate input#course_starts_at': 'changeDateAction'
    'changeDate input#course_ends_at': 'changeDateAction'
    'keyup input#course_ends_at': 'changeDateAction'
    'click a.multi-day': 'multiDayAction'
    'change :checkbox': 'checkSkipAction'

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
        isSkipped: day.is_skipped

    @updateDays()

    if @$courseEndField.val() != '' && @$courseStartField.val() != @$courseEndField.val()
      @switchToMultiDay()
    else
      @switchToSingleDay()

  setupDatepicker: ->
    @format = SHORT_FORMAT
    @parsedFormat = DPGlobal.parseFormat(@format)
    @longFormat = LONG_FORMAT
    @parsedLongFormat = DPGlobal.parseFormat(@longFormat)
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

  longFormatDate: (date) ->
    DPGlobal.formatDate(date, @parsedLongFormat, 'en')

  dateToIdentifier: (date) ->
    month = date.getUTCMonth() + 1
    month = "0#{month}" if month <= 9
    day = date.getUTCDate()
    day = "0#{day}" if day <= 9

    "#{date.getUTCFullYear()}-#{month}-#{day}"

  # Changing campaign end date

  changeCampaignEndDate: ->
    start = @parseDate(@$courseStartField.val())

    campaignEndDate = new Date()
    numberOfDays = 6
    campaignEndDate.setTime(start.getTime() - numberOfDays * 24 * 60 * 60 * 1000)
    daysLeft = campaignEndDate.daysFromNow()

    # Render the template
    html = JST['templates/course_campaign_notice']({
      isBarelyEnoughTime: (daysLeft > 0 && daysLeft <= 7)
      isEnoughTime: (daysLeft > 7)
      endDate: @formatDate(campaignEndDate),
      daysLeft: daysLeft
    })
    @$campaignEndNotice.html(html).show()

  # Changing any date

  changeDateAction: ->
    # If there's no end date, copy from start date
    if @$courseEndField.val() == ''
      @$courseEndField.val(@$courseStartField.val())

    # If end date is before start date, set end date to start date
    if @$courseEndField.val() != ''
      start = @parseDate(@$courseStartField.val())
      end = @parseDate(@$courseEndField.val())
      if end < start
        @$courseEndField.val(@$courseStartField.val())

    # If we're in the single day mode, end date should follow start date
    if !@isMultiDay && @$courseStartField.val() != @$courseEndField.val()
      @$courseEndField.val(@$courseStartField.val())

    @updateDays()

    @changeCampaignEndDate()

  checkSkipAction: ->
    @updateDays()

  updateDays: ->
    @storeSchedulesByDays()

    startVal = @$courseStartField.val()
    endVal = @$courseEndField.val()
    if startVal == ''
      return @$courseSchedule.hide()

    start = @parseDate(startVal)
    if endVal == ''
      end = @parseDate(startVal)
    else
      end = @parseDate(endVal)

    days = []

    while start <= end
      identifier = @dateToIdentifier(start)
      day = 
        date: start
        identifier: identifier
        checkboxId: "skip-#{identifier}"
        label: @longFormatDate(start)
        
      if @schedulesByDays[identifier]
        schedule = @schedulesByDays[identifier]
        day.startsAt = schedule.startsAt
        day.endsAt = schedule.endsAt
        day.isSkipped = schedule.isSkipped

      days.push(day)
              
      newDate = start.setDate(start.getDate() + 1)
      start = new Date(newDate)

    @render(days)

  storeSchedulesByDays: ->
    # Caches entered schedules
    @$courseSchedule.find('div.day').each (i, row) =>
      $row = $(row)
      date = $row.find('input.date').val()
      startsAt = $row.find('input.start').val()
      endsAt = $row.find('input.end').val()
      skip = $row.find(':checkbox').is(':checked')
      @schedulesByDays[date] = {startsAt: startsAt, endsAt: endsAt, isSkipped: skip}

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

    @switchToMultiDay()

  switchToMultiDay: ->
    @isMultiDay = true
    @$courseEndGroup.show()
    @$multiDayGroup.hide()

  switchToSingleDay: ->
    @isMultiDay = false
    @$courseEndGroup.hide()
    @$multiDayGroup.show()