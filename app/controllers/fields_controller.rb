class FieldsController < ApplicationController

  def index
    @fields = Field.all

    render 'fields/index'
  end

  def create
    points = []

    20.times do | num |
      points.push([])
      20.times do | num2|
        points[num][num2] = 0
      end
    end

    @field = Field.create(name: params[:field][:name], points: points, player_one_id: current_user.id)

    render 'fields/show'
  end

  def receive_request

    field = Field.find(params[:id])
    field.update_attributes(second_player_id: current_user.id, closed: true)

  end

  def new_point
    @field = Field.find(params[:id])
    @x = params[:x].to_i
    @y = params[:y].to_i
    @steps = { x: [0,-1,1,0], y: [-1,0,0,1] }

    temp_points = @field.points
    temp_points[@x][@y] = 1

    @field.update_attributes(points: temp_points)

    find_captured_zones

    ActionCable.server.broadcast 'game_channel', data: 'obama'
  end

  def find_captured_zones

    if there_is_nearest_points?
      search_captured_zone
    end

  end

  def search_captured_zone

    p '!'

    4.times do |i|
      if(@field.points[@x + @steps[:x][i]][@y + @steps[:y][i]] == "0")
        last_turn = 0
        has_end = true
        current_position = [ @x + @steps[:x][i] , @y + @steps[:y][i] ]
        checked_positions = []

        checked_positions.push( current_position )
          while(true)
            last_turn += 1

            4.times do |j|
              next_position = [ current_position[0] + @steps[:x][j], current_position[1] + @steps[:y][j] ]

              if(@field.points[next_position[0]][next_position[1]] == "0" && !checked_positions.include?(next_position) )
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

    p 'chp'
    p checked_positions

    captured_points = []
    captured_zone = []

    checked_positions.each do | pos |
      4.times do |i|
        next_checked = [ pos[0] + @steps[:x][i], pos[1] + @steps[:y][i] ]

        if( @field.points[next_checked[0]][next_checked[1]] == "1" && !captured_points.include?( next_checked ))
          captured_points.push( next_checked )
        end
      end
    end

    p 'cp:'
    p captured_points

    temp_point = captured_points[0]
    captured_zone.push( temp_point )

    captured_points.length.times do |q|
      p 'continue'
      for k in -1..1
        do_break2 = false
        for k2 in -1..1
          do_break = false
          if(@field.points[temp_point[0] + k][temp_point[1] + k2] == "1")
            captured_points.each do | point |
              if(temp_point[0] + k == point[0] && temp_point[1] + k2 == point[1] && !captured_zone.include?( point ))
                temp_point = point
                captured_zone.push( temp_point )
                p 'back'
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

    p 'cz'
    p captured_zone
    CapturedZone.create(player_id: current_user.id, field_id: params[:id], points: captured_zone)

  end

  def there_is_nearest_points?

    count = 0

    4.times.each do |i|
      count+=1 if @field.points[@x + @steps[:x][i]][@y + @steps[:y][i]] != "0"
    end

    return count >= 2 ? true : false
  end

  def show
    @field = Field.find(params[:id])
    @friendly_captured_zones = []
    @enemy_captured_zones = []

    CapturedZone.where(player_id: current_user.id, field_id: params[:id]).each do |zone|
      @friendly_captured_zones.push(zone.points)
    end

    CapturedZone.where(player_id: current_user.id == @field.player_one_id ? @field.player_two_id : @field.player_one_id, field_id: params[:id]).each do |zone|
      @enemy_captured_zones.push(zone.points)
    end

    render 'fields/show'
  end

end
