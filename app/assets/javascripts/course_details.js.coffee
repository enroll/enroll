class window.CourseDetails extends Spine.Controller
  events:
    'keyup #course_name': 'typeAction'

  elements:
    '#course_name': '$courseName'
    '#course_url': '$courseUrl'

  constructor: ->
    super
    @isEnabled = (@$courseUrl.val() == '')
    

  typeAction: ->
    if @$courseName.val() == ''
      @isEnabled = true

    if @isEnabled
      slug = @$courseName.val().toLowerCase()
        .replace(///\s+///g, '-')
        .replace(///[^\w-]+///g, '')
        .replace(///[-]+///, '-')
        .replace(///^-///, '')
        .replace(///-$///, '')
      @$courseUrl.val(slug)