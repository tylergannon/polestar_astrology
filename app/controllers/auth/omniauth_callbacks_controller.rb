# frozen_string_literal: true
class Auth::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    @member = Member.find_by_email(request.env["omniauth.auth"].info.email)

    if @member.present?
      @member.update first_name: request.env["omniauth.auth"].info.first_name,
        last_name: request.env["omniauth.auth"].info.last_name
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Google"
      sign_in_and_redirect @member, :event => :authentication
    else
      redirect_to new_member_session_path
    end
  end
end
