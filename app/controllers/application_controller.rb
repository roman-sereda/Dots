class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def index
    render 'game/field'
  end
end
