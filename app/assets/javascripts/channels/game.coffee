App.game = App.cable.subscriptions.create "GameChannel",
  connected: ->
    console.log('connected')

  disconnected: ->
    console.log('disconnected')

  received: (data) ->
    console.log(data)
    console.log(data.coors)
    console.log('look up')
    if data.type_to_add = 'point'
      draw_point(data.coors, data.user, data.turn)
    if data.type_to_add = 'captured_zone'
      update_score(data.owner_score, data.guest_score)
      draw_zone(data.coors, data.user)
