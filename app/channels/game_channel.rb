class GameChannel < ApplicationCable::Channel

  def subscribed
    field = Field.find(params[:id])
    stream_from "game_channel"
  end

  def unsubscribed

  end
end
