class window.CoursePricing extends Spine.Controller
  elements:
    # Sections
    '.pricing-details-section': '$pricingDetailsSection'

    # Fields
    '#course_price_per_seat_in_dollars': '$cost'
    '#course_min_seats': '$minSeats'
    '#course_max_seats': '$maxSeats'
    'label#for-profit input': '$forProfitRadio'
    'label#for-fun input': '$forFunRadio'
    'tr.course_price_per_seat_in_dollars': '$coursePriceRow'

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

    if @isFree
      @selectFun()
    else
      @selectProfit()

    if !@isFilledIn
      @$pricingDetailsSection.hide()
      @$forFunRadio.attr('checked', false)
      @$forProfitRadio.attr('checked', false)

    

  bindChangeEvent: (el) ->
    @$(el).on 'propertychange input', @updateCourseCalculator

  selectFunAction: ->
    return if @isDisabled
    @selectFun()

  selectFun: ->
    @$cost.val(0).hide()
    $('.free-text').remove()
    @$cost.parent().append("<strong class='free-text'>FREE</strong>")
    @$calculator.hide()
    @$coursePriceRow.hide()
    @$pricingDetailsSection.show()

    @$forFunRadio.attr('checked', true)

  selectProfitAction: ->
    return if @isDisabled
    @selectProfit()

  selectProfit: ->
    if @$cost.val() == '' || @$cost.val() == '0'
      @$cost.val(10)
    if @$minSeats.val() == ''
      @$minSeats.val(2)
    @$cost.show()
    $('.free-text').remove()
    @$calculator.show()
    @updateCourseCalculator()
    @$coursePriceRow.show()
    @$pricingDetailsSection.show()

    @$forProfitRadio.attr('checked', true)

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

    fee = parseFloat(cost * 0.1).toFixed(2)
    if isNaN fee
      fee = parseFloat(0).toFixed(2)
    minFees = parseFloat(fee * minSeats).toFixed(2)
    maxFees = parseFloat(fee * maxSeats).toFixed(2)

    minRevenue = parseFloat((minSeats * cost) - minFees).toFixed(2)
    maxRevenue = parseFloat((maxSeats * cost) - maxFees).toFixed(2)

    if isNaN minRevenue
      $(".min-seat-revenue").text "$0"
    else
      $(".min-seat-revenue").text "$#{minRevenue}"
    if isNaN maxRevenue
      $(".max-seat-revenue").text "$0"
    else
      $(".max-seat-revenue").text "$#{maxRevenue}"
