class FieldsController < ApplicationController

  def create
    points = []

    20.times do | num |
      20.times do | num2|
        points[num - 1][num2 - 1] = 0
      end
    end

    Field.create(name: field_params, points: points)

  end

  def field_params
    params.permit(:field).include(:name)
  end

end
