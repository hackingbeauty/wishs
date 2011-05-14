module SessionsHelper

  def sign_in(user)
    !current_user.nil?
  end

  def current_user=(user)
    @current_user ||= user_from_remember_token
  end

   def user_from_remember_token
    remember_token = cookies[:remember_token]
    User.find_by_remember_token(remember_token) unless remember_token.nil?
   end

   def destroy
    sign_out
    redirect_to root_path
   end

   def sign_out
    cookies.delete(:remember_token)
    self.current_user = nil
   end
   def signed_in?
    !current_user.nil?
  end
end