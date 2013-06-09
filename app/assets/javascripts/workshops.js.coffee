calculateRevenue = ->
  $seats = $("#input-seats").val()
  $cost = $("#input-cost").val()
  $revenue = parseInt($seats) * parseInt($cost)
  if isNaN $revenue
    $("#revenue").text "$0"
  else
    $("#revenue").text "$#{$revenue}"

updateWorkshopCost = ->
  $cost = $("#input-cost").val()
  $(".workshop-cost").text($cost)

$(document).ready ->
  $("#input-seats").keyup calculateRevenue
  $("#input-cost").keyup calculateRevenue
  $("#input-seats").blur calculateRevenue
  $("#input-cost").blur calculateRevenue

  $("#input-cost").keyup updateWorkshopCost
  $("#input-cost").blur updateWorkshopCost
  
