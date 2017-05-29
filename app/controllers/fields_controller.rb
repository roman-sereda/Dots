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
    field = Field.find(params[:id])

    temp_points = field.points
    temp_points[params[:x].to_i][params[:y].to_i] = 1

    field.update_attributes(points: temp_points)
  end

  def show
    @field = Field.find(params[:id])

    render 'fields/show'
  end

end
