App.game = App.cable.subscriptions.create "GameChannel",
  connected: ->
    console.log('connected')

  disconnected: ->
    console.log('disconnected')

  received: (data) ->
    console.log('receive data')
