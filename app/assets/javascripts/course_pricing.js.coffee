class window.CoursePricing extends Spine.Controller
  elements:
    # Fields
    '#course_price_per_seat_in_dollars': '$cost'
    '#course_min_seats': '$minSeats'
    '#course_max_seats': '$maxSeats'

    # Calculator
    '#revenue-calculator': '$calculator'
    '.min-seats': '$calculatorMinSeats'
    '.max-seats': '$calculatorMaxSeats'
    '.ticket-price': '$calculatorTicketPrice'


  events:
    'click #for-fun': 'selectFunAction'
    'click #for-profit': 'selectProfitAction'

  constructor: ->
    super
    @bindChangeEvent('#course_min_seats')
    @bindChangeEvent('#course_max_seats')
    @bindChangeEvent('#course_price_per_seat_in_dollars')
    @updateCourseCalculator()

  bindChangeEvent: (el) ->
    @$(el).on 'propertychange input', @updateCourseCalculator

  selectFunAction: ->
    @$cost.val(0).hide()
    $('.free-text').remove()
    @$cost.parent().append("<strong class='free-text'>FREE</strong>")
    @$calculator.hide()

  selectProfitAction: ->
    @$cost.val(199).show()
    $('.free-text').remove()
    @$calculator.show()
    @updateCourseCalculator()

  # Updating calculator

  updateCourseCalculator: =>
    minSeats = @$minSeats.val()
    maxSeats = @$maxSeats.val()
    cost = parseFloat(@$cost.val()).toFixed(2)
    if isNaN cost
      cost = parseFloat(0).toFixed(2)

    @$calculatorMinSeats.text(minSeats)
    @$calculatorMaxSeats.text(maxSeats)
    @$calculatorTicketPrice.text("$#{cost}")

    minRevenue = parseFloat(minSeats * cost).toFixed(2)
    maxRevenue = parseFloat(maxSeats * cost).toFixed(2)

    if isNaN minRevenue
      $(".min-seat-revenue").text "$0"
    else
      $(".min-seat-revenue").text "$#{minRevenue}"
    if isNaN maxRevenue
      $(".max-seat-revenue").text "$0"
    else
      $(".max-seat-revenue").text "$#{maxRevenue}"