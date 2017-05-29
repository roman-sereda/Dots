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

    @field = Field.create(name: params[:field][:name], points: points)

    render 'fields/show'
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

    p checked_positions

    capture_points = []
    capture_zone = []

    checked_positions.each do | pos |
      4.times do |i|
        p pos[0]
        next_checked = [ pos[0] + @steps[:x][i], pos[1] + @steps[:y][i] ]
        p next_checked

        if( @field.points[next_checked[0]][next_checked[1]] == "1" && !capture_points.include?( next_checked ))
          capture_points.push( next_checked )
        end
      end
    end

    capture_points.each do |pos|
      p pos
    end

    temp_point = capture_points[0]

    p capture_points.length

    capture_points.length.times do |i|
      p i
      capture_points.length.times do |j|
        4.times do |k|
          temp_zone = [ temp_point[0] + @steps[:x][k], temp_point[1] + @steps[:y][k] ]

          p "! #{temp_zone}"
          p "# #{capture_points[j]}"

          if(temp_zone == capture_points[j] && !capture_zone.include?( temp_zone ))
            capture_zone.push( temp_point )
            temp_point = temp_zone
          end
        end
      end
    end

    p capture_zone

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

    render 'fields/show'
  end

end
