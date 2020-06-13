class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  layout :layout_by_resource

  private

  def layout_by_resource
    if devise_controller? || controller_name == 'home'
      "home"
    else
      "application"
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  end
end
