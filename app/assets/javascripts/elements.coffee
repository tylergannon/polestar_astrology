$(document).on 'turbolinks:load', ->
  $(document).on 'click', '.linkable', (e) ->
    unless this.tagName == 'A'
      Turbolinks.visit e.currentTarget.dataset.href
