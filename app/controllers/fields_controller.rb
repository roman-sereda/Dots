class FieldsController < ApplicationController
  before_action :qwe, only: [:new_point, :show]

  def games
    @fields = Field.all
    @avaliable_games = Field.where(closed: false)
    @my_games = (Field.where(owner_id: current_user.id) + Field.where(guest_id: current_user.id)).uniq
  end

  def qwe
    @steps = { x: [0,-1,1,0], y: [-1,0,0,1] }
    @field = Field.find(params[:id])
    @owner = @field.owner_id == current_user.id ? true : false
    @enemy = @owner ? 2 : 1
    @player = @owner ? 1 : 2
  end

  def index
    games
  end

  def create
    points = []

    20.times do | num |
      points.push([])
      20.times do | num2|
        points[num][num2] = 0
      end
    end

    @field = Field.create(name: params[:field][:name], points: points, owner_id: current_user.id, turn: 1)

    redirect_to action: "show", id: @field.id
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

    p 'player'
    p @player
    p 'enemy'
    p @enemy
    p 'turn'
    p @field.turn

    ActionCable.server.broadcast 'game_channel', { type_to_add: 'point', turn: @field.turn, coors: [@x, @y], user: current_user.id, turn: @enemy}
  end

  def find_captured_zones
    if there_is_nearest_points?
      search_captured_zone
    end

  end

  def search_captured_zone
    4.times do |i|
      if(@field.points[@x + @steps[:x][i]][@y + @steps[:y][i]].to_i != @player)
        last_turn = 0
        has_end = true
        current_position = [ @x + @steps[:x][i] , @y + @steps[:y][i] ]
        checked_positions = []

        checked_positions.push( current_position )
          while(true)
            last_turn += 1

            4.times do |j|
              next_position = [ current_position[0] + @steps[:x][j], current_position[1] + @steps[:y][j] ]

              if(@field.points[next_position[0]][next_position[1]].to_i != @player && !checked_positions.include?(next_position) )
                checked_positions.push(next_position)
              end
            end

            break if checked_positions.length == last_turn

            current_position = checked_positions[last_turn]

            if (current_position[0] > 18 || current_position[0] < 0 || current_position[1] > 18 || current_position[1] < 0)
    					has_end = false;
    					break;
    				end
          end

          if( has_end )
            create_capture_zone(checked_positions)
          end
      end
    end

  end

  def create_capture_zone checked_positions
    captured_points = []
    captured_zone = []

    checked_positions.each do | pos |
      4.times do |i|
        next_checked = [ pos[0] + @steps[:x][i], pos[1] + @steps[:y][i] ]

        if( @field.points[next_checked[0]][next_checked[1]].to_i == @player && !captured_points.include?( next_checked ))
          captured_points.push( next_checked )
        end
      end
    end

    temp_point = captured_points[0]
    captured_zone.push( temp_point )

    captured_points.length.times do |q|
      for k in -1..1
        do_break2 = false
        for k2 in -1..1
          do_break = false
          if(@field.points[temp_point[0] + k][temp_point[1] + k2].to_i == @player)
            captured_points.each do | point |
              if(temp_point[0] + k == point[0] && temp_point[1] + k2 == point[1] && !captured_zone.include?( point ))
                temp_point = point
                captured_zone.push( temp_point )
                do_break = true
                break
              end
            end
          end
          if(do_break)
            do_break2 = true
            break
          end
        end
        break if do_break2
      end
    end

    CapturedZone.create(player_id: current_user.id, field_id: params[:id], points: captured_zone)

    score = 0

    checked_positions.each do |point|
      if(@field.points[point[0]][point[1]].to_i == @enemy)
        score += 1
        @field.points[point[0]][point[1]] = "#{-@enemy}"
      end
    end

    if(@owner)
      @field.update_attributes(owner_score: @field.owner_score + score)
    else
      @field.update_attributes(guest_score: @field.guest_score + score)
    end

    ActionCable.server.broadcast 'game_channel', {  type_to_add: 'capture_zone',
                                                    coors: captured_zone,
                                                    user: current_user.id,
                                                    owner_score: @field.owner_score,
                                                    guest_score: @field.guest_score }

  end

  def there_is_nearest_points?

    count = 0

    for i in -1..1
      for j in -1..1
        count+=1 if @field.points[@x + i][@y + j].to_i == @player
      end
    end
    return count >= 3 ? true : false
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

    games

    p @player

    render 'fields/show'
  end

end
