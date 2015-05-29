def current_user
  User.find(session[:user_id])
end

def set_user(user=nil)
  session[:user_id] = (user || Fabricate(:user)).id
end

def signout_user
  session[:user_id] = nil
end

def user_logged_in?
  session[:user_id] != nil
end

def sign_in(a_user=nil)
  user = a_user || Fabricate(:user)
  visit sign_in_path
  fill_in "email", with: user.email
  fill_in "password", with: user.password
  find_button("Sign in").click
end