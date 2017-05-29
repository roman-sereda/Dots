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
      p 'yes'
    else
      p 'no'
    end

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
