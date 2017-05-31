class FieldsController < ApplicationController
  include FieldHelper
  before_action :field_data, only: [:new_point, :show, :surrender]

  def index
    fields_data
  end

  def create
    @field = Field.create(name: params[:field][:name], points: empty_field, owner_id: current_user.id, turn: 1)
    redirect_to action: "show", id: @field.id
  end

  def show
    @current_user_id = current_user.id
    @friendly_captured_zones = []
    @enemy_captured_zones = []

    CapturedZone.where(player_id: current_user.id, field_id: params[:id]).each do |zone|
      @friendly_captured_zones.push(zone.points)
    end

    CapturedZone.where(player_id: @owner ?  @field.guest_id : @field.owner_id, field_id: params[:id]).each do |zone|
      @enemy_captured_zones.push(zone.points)
    end

    fields_data
    render 'fields/show'
  end

  def surrender
    @field = Field.find(params[:id])
    @field.update_attributes(@owner ? {owner_surrender: true} : {guest_surrender: true})

    if(@field.owner_surrender && @field.guest_surrender)
      @field.update_attributes(is_finished: true)
    end

    redirect_to action: "index"
  end

  def receive_request
    field = Field.find(params[:id])
    field.update_attributes(guest_id: current_user.id, closed: true)

    redirect_to action: "show"
  end

  def new_point
    @x = params[:x].to_i
    @y = params[:y].to_i
    temp_points = @field.points
    temp_points[@x][@y] = @player

    @field.update_attributes(points: temp_points, turn: @enemy)
    find_captured_zones

    ActionCable.server.broadcast 'game_channel', { type_to_add: 'point', turn: @field.turn, coors: [@x, @y], user: current_user.id, turn: @enemy, field_id: @field.id}
  end
end
