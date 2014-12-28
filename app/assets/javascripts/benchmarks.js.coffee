# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

class window.benchmark_selector
  constructor: ->
    $('select#ruby_benchmark').on 'change', ->
      page = $('select#ruby_benchmark').val()
      window.location = "/benchmarks/#{page}"

class window.source_toggle
  constructor: ->
    $("button[data-toggle-btn='true']").on 'click ->', ->
      el = $(this)
      target = el.attr('data-toggle-elem')
      $("div.CodeRay[data-toggle-name='#{target}']").toggle()