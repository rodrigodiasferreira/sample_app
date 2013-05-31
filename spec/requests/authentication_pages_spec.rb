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
    before { visit signin_path }
  
      it { should have_content('Sign in') }
      it { should have_title('Sign in') }
  end
end
