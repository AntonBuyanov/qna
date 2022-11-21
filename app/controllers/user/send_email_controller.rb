class User::SendEmailController < ApplicationController
  def create
    email = user_params[:email]

    if User.find_by(email: email).nil?
      password = Devise.friendly_token[0, 20]
      user = User.create!(email: email, password: password, password_confirmation: password)
      user.authorizations.create(provider: session[:auth_provider], uid: session[:auth_uid])
    else
      redirect_to root_path, alert: 'Something went wrong'
    end
  end

  private

  def user_params
    params.require(:user).permit(:email)
  end
end
