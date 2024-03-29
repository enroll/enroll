# This is a manifest file that'll be compiled into application.js, which will include all the files
# listed below.
#
# Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
# or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
#
# It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
# compiled file.
#
# WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
# GO AFTER THE REQUIRES BELOW.
#
#= require jquery
#= require jquery_ujs
#= require jquery.spin
#= require jquery.timepicker.js
#= require sugar
#= require angular
#= require angular-strap
#= require bootstrap
#= require bootstrap-datepicker
#= require spine
#= require tilt-jade/runtime
#= require modernizr.custom.18921.js
#= require retina_tag
#= require magnific-popup
#= require jquery.form
#= require draggable_background


#= require_tree ./templates
#= require_tree .
#= require_self

@App = angular.module('EnrollApp', ["$strap.directives"])

$(document).on('ready page:load', ->
  angular.bootstrap(document, ['EnrollApp'])
)

# General

$(document).ready ->
  $('form.simple_form').find('input').keyup (ev) ->
    wrapper = $(@).parents('.has-error:first')
    wrapper
      .removeClass('has-error')
      .find('.text-danger').fadeOut()
