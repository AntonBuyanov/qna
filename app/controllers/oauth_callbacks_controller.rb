class OauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    oauth('github')
  end

  def vkontakte
    oauth('vkontakte')
  end

  private

  def oauth(provider)
    auth = request.env['omniauth.auth']
    @user = User.find_for_oauth(auth)

    if @user&.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: provider) if is_navigational_format?
    elsif auth && auth[:uid]
      session[:auth_provider] = auth[:provider]
      session[:auth_uid] = auth[:uid]&.to_s

      render 'user/send_email/new'
    else
      redirect_to root_path, alert: 'Something went wrong'
    end
  end
end
