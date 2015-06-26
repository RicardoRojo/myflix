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

def sign_in(user = nil)
  user ||= Fabricate(:user)
  visit sign_in_path
  fill_in "email", with: user.email
  fill_in "password", with: user.password
  find_button("Sign in").click
end

def go_to_video(video)
  find("a[href='/videos/#{video.id}']").click # looks for the link
end

def expect_to_have_text(content)
  expect(page).to have_content(content)
end

def expect_to_not_have_text(text)
  expect(page).to_not have_content(text)
end

def sign_out
  click_link "Sign Out"
end
