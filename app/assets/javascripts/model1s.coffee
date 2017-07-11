# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

@send_form =  ->
  f=$('form')
  a=f.attr('action')
  $.ajax({
    type: 'POST',
    url: a,
    data: f.serialize()
    dataType: 'json'
  });


# Envia formulario al presionar enlaces con clase fichacambia 
# con más de 5 segundos de diferencia entre un click y el siguiente
$(document).on('click', 'a.sendform[href^="#"]', (e) ->
  e.preventDefault()
  send_form()
  return
)

