# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

class window.benchmark_selector
  constructor: ->
    $('select#ruby_benchmark').on 'change', ->
      page = $('select#ruby_benchmark').val()
      section = $('select#ruby_benchmark').data('section')
      window.location = "/#{section}/#{page}" + window.location.search

    $('select#ruby_version').on 'change', ->
      ruby = $('select#ruby_version').val()
      window.location = window.location.pathname + "?ruby=#{ruby}"

class window.source_toggle
  constructor: ->
    $("button[data-toggle-btn='true']").on 'click', ->
      el = $(this)
      target = el.attr('data-toggle-elem')
      remote = $("div[data-toggle-name='#{target}']")
      remote.toggle()


window.toggle_full_screen = (selector) ->
  element = $("#{selector}")

  if element.hasClass 'modal-chart'
    element.removeClass 'modal-chart'
    element.addClass 'modal-chart-small'
  else
    element.removeClass 'modal-chart-small'
    element.addClass 'modal-chart'

  element.highcharts().reflow()
