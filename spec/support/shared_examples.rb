shared_examples "require user" do
  it "redirects to root path" do
    signout_user
    action
    expect(response).to redirect_to root_path
  end
end
shared_examples "redirect to sign in" do
  it "redirects to root path" do
    signout_user if user_logged_in?
    action
    expect(response).to redirect_to sign_in_path
  end
end
shared_examples "tokenable" do
  it "generates a token" do
    object.generate_token
    expect(object.token).not_to be_nil
  end
end