$ ->
  a = 10

  b = a + 5

  c = 10 if b > 3

  # this is a comment

  capitalize = (string) ->
    string.charAt(0).toUpperCase() + string.slice(1)

  console.log capitalize("tam")

  # $(".btn").click ->
  #   $(@).addClass "btn-danger"
  #   false

  # $(".btn").click ->
  #   $(@).toggleClass("btn-primary").toggleClass("btn-danger")
  #   false
