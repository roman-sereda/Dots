App.game = App.cable.subscriptions.create "GameChannel",
  connected: ->
    console.log('connected')

  disconnected: ->
    console.log('disconnected')

  received: (data) ->
    if data.type_to_add = 'point'
      actions(data.turn)
      draw_point(data.coors, data.user)
    if data.type_to_add = 'captured_zone'
      update_score(data.owner_score, data.guest_score)
      draw_zone(data.coors, data.user)
