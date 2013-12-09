class ApplicationController < ActionController::Base
  protect_from_forgery

  def doorkeeper_oauth_client
    @client ||= OAuth2::Client.new(ENV["DOORKEEPER_APP_ID"], ENV["DOORKEEPER_APP_SECRET"], :site => ENV["DOORKEEPER_PROVIDER_URL"])
  end

  def doorkeeper_access_token
    @token ||= OAuth2::AccessToken.new(doorkeeper_oauth_client, current_user.doorkeeper_access_token) if current_user
  end

  def authenticate_api_call_from_token!
    user_email = params[:user_email].presence
    user       = user_email && User.find_by_email(user_email)

    # Notice how we use Devise.secure_compare to compare the token
    # in the database with the token given in the params, mitigating
    # timing attacks.
    #if user && Devise.secure_compare(user.doorkeeper_access_token, params[:user_token])
      #sign_in user, store: false
    #end
    auth_token = params[:user_token].presence
    if user && auth_token
      doorkeeper_token = OAuth2::AccessToken.new(doorkeeper_oauth_client, auth_token)
      auth_response = doorkeeper_token.get("api/v1/me.json")
      if auth_response.status == 200
        return true
      else
        return false
      end
    end
  end
end
