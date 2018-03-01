document.addEventListener 'turbolinks:load', ->
  $($('input[type=text], textarea')[0]).focus()

  $(document).on 'click', '.chart_display [data-palace-id]', (e) ->
    palace_id = $(e.target).parents('.palace').data('palace-id')
    $('.notes .palace-notes').addClass('d-none')
    $('#notes-' + palace_id).removeClass('d-none')
    document.rocket_shit.take_off("now")

  $(document).on 'keyup', 'input#chart-search', (e) ->
    console.log('laggerbagger')
    regexp = new RegExp(this.value, "i")
