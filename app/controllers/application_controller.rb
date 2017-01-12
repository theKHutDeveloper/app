class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :configure_signup_parameters, if: :devise_controller?

  protected

  def configure_signup_parameters
    devise_parameter_sanitizer.permit(:sign_up) do |user_params|
      user_params.permit(:firstname, :lastname, :email, :password, :password_confirmation)
    end

    devise_parameter_sanitizer.permit(:account_update) do |user_params|
      user_params.permit(:firstname, :lastname, :email, :password, :password_confirmation, 
        :current_password)
    end
  end
end
