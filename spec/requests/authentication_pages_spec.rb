require 'spec_helper'

describe "Authentication" do

  describe "GET /authentication_pages" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get signin_path
      response.status.should be(200)
    end
  end

  subject { page }

  describe "signin page" do
    before { visits_signin_page }
  
      it { should have_content('Sign in') }
      it { should have_title('Sign in') }

    describe "with invalid blank information" do

      before { submits_invalid_blank_signin }

      it { should have_title('Sign in') }
      #it { should have_selector('div.alert.alert-error', text: 'Invalid') }
      it { should have_error_message('Invalid') }
      
      describe "after visiting another page" do
        before { click_link "Home" }
        it { should_not have_selector('div.alert.alert-error') }
      end

    end
    
    describe "with invalid filled information" do

      let(:user) { FactoryGirl.create(:user) }
      before do
        fill_in "Email",    with: user.email.upcase
        fill_in "Password", with: ""
        click_button "Sign in"
      end

      it { should have_title('Sign in') }
      it { should have_selector('div.alert.alert-error', text: 'Invalid') }
      it { expect(page).to have_field(:email, with: user.email.upcase) }
      #it { find_field('email').value.should eq user.email.upcase }
      
      describe "after visiting another page" do
        before { click_link "Home" }
        it { should_not have_selector('div.alert.alert-error') }
      end

    end

    describe "with valid information" do
      let(:user) { user_has_account }
      #before do
      #  fill_in "Email",    with: user.email.upcase
      #  fill_in "Password", with: user.password
      #  click_button "Sign in"
      #end
      before { valid_signin(user) }

      #it { should_see_profile_page(user) }
      it { should have_title(user.name) }
      it { should have_link('Profile',     href: user_path(user)) }
      it { should have_link('Settings',    href: edit_user_path(user)) }
      it { should have_link('Sign out',    href: signout_path) }
      it { should_not have_link('Sign in', href: signin_path) }
      
      describe "followed by signout" do
        before { click_link "Sign out" }
        it { should have_link('Sign in') }
      end
    end
    
  end
  
  describe "authorization" do

    describe "for non-signed-in users" do
      let(:user) { FactoryGirl.create(:user) }

      describe "in the Users controller" do

        describe "visiting the edit page" do
          before { visit edit_user_path(user) }
          it { should have_title('Sign in') }
        end

        describe "submitting to the update action" do
          before { patch user_path(user) }
          specify { expect(response).to redirect_to(signin_path) }
        end
      end
    end
  end
  
end
