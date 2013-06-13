include ApplicationHelper

def valid_signin(user)
  fill_in "Email",    with: user.email
  fill_in "Password", with: user.password
  click_button "Sign in"
  # Sign in when not using Capybara as well.
  cookies[:remember_token] = user.remember_token
end

def sign_in(user)
  visits_signin_page
  valid_signin(user)
end

RSpec::Matchers.define :have_error_message do |message|
  match do |page|
    expect(page).to have_selector('div.alert.alert-error', text: message)
  end
end

def visits_signin_page()
  visit signin_path
end

def submits_invalid_blank_signin()
  click_button "Sign in"
end

RSpec::Matchers.define :should_see_profile_page do |user|
  match do |page|
    expect(page).to have_title(user.name)
    expect(page).to have_link('Profile',     href: user_path(user))
    expect(page).to have_link('Settings',    href: edit_user_path(user))
    expect(page).to have_link('Sign out',    href: signout_path)
    expect(page).to have_link('Sign in',     href: signin_path)
  end
end


def user_has_account()
  @user = FactoryGirl.create(:user)
end