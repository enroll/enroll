class window.CourseForm extends Spine.Controller
  elements:
    'input#course_starts_at': '$courseStartField'
    'input#course_ends_at': '$courseEndField'

  events:
    'changeDate input#course_starts_at': 'changeStartDateAction'

  constructor: ->
    super

  changeStartDateAction: ->
    if @$courseEndField.val() == ''
      @$courseEndField.val(@$courseStartField.val())
