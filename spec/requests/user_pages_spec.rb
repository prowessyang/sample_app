require 'spec_helper'

describe "UserPages" do
	subject {page}
	describe "signup page" do
		before {visit signup_path}
		it {should have_content('Sign up')}
		it {should have_title('Sign up')}
	end
	describe "profile page" do
		let (:user) {FactoryGirl.create(:user)}
		before {visit user_path(user)}
		it {should have_content(user.name)}
		it {should have_title(user.name)}
	end
	describe "test signup" do
		before{visit signup_path}
		let(:submit) {"Create my account"}
		it "submitting an empty form wont register an user" do
			expect {click_button submit}.not_to change(User, :count)
		end
		describe "signup with invalid information" do
			before do
				fill_in "Name", with: " "
				fill_in "Email", with: "kakaka"
				fill_in "Password", with: "asdf"
				fill_in "Confirmation", with: "fasfasdf"
				click_button submit
			end
			it {should have_title('Sign up')}
			it {should have_content('error')}
		end

		describe "signup with valid information" do
			before do
				fill_in "Name", with: "Example User"
				fill_in "Email", with: "user@example.com"
				fill_in "Password", with: "gravity"
				fill_in "Confirmation", with:"gravity"
			end
			it "should create a user" do
				expect {click_button submit}.to change(User, :count).by(1)
			end
			describe "after saving the user" do
				before {click_button "Create my account"} 
					let(:user) {User.find_by(email:'user@example.com')}
					it {should have_link('Sign out')}
					it {should have_title(user.name)} # or ("#{user.name}")
					it {should have_selector('div.alert.alert-success', text:'Welcome')}
					it {should_not have_link('Sign in')}
			end
		end
	end
end
