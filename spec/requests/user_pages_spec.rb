require 'spec_helper'

describe "UserPages" do
	subject {page}

	describe "User index page" do
		let(:user) {FactoryGirl.create(:user)}
		before (:each) do
			sign_in user
			visit users_path
		end
		it {should have_title('All users')}
		it {should have_content('All users')}

		describe "paginate" do
			before (:all) { 30.times { FactoryGirl.create(:user)} }
			after (:all) { User.delete_all }
			it {should have_selector('div.pagination')}

			it "should list every user" do
				User.paginate(page: 1).each do |user|
					expect(page).to have_selector('li', text:user.name)
				end
			end
		end

		describe "delete link" do
			it {should_not have_link('delete')}
			describe "sign in as admin user" do
				let(:admin){FactoryGirl.create(:admin)}
				before do
					sign_in admin # I don't qutie get it here. How :admin in let clause change to admin variable here?
					visit users_path
				end
				it {should have_link('delete', href: user_path(User.first))} #delete action is a destroy http quest to user_path
				it "should be able to delete a user" do
					expect do
						click_link('delete', match: :first) #tells Capybara that we don't care which one. Do it to the first one you see. 
					end.to change(User, :count).by(-1) # it's weird but you can't use change(User.count)
				end 
				it {should_not have_link('delete', href: user_path(admin))}
			end
			describe "when not signed in" do # to prevent unregistered user to modify database through command line.
				before {delete user_path(user)}
				specify{ expect(response).to redirect_to signin_path }
			end
		end
	end

	describe "signup page" do
		before {visit signup_path}
		it {should have_content('Sign up')}
		it {should have_title('Sign up')}
	end
	describe "profile page" do
		let (:user) {FactoryGirl.create(:user)}
		let! (:m1) {FactoryGirl.create(:micropost, user: user, content:"Food", created_at: 1.day.ago )}
		let! (:m2) {FactoryGirl.create(:micropost, user: user, content:"sex", created_at: 1.hour.ago)}
		before do
			sign_in(user)
			visit user_path(user)
		end
		it {should have_content(user.name)}
		it {should have_title(user.name)}
		describe "microposts" do
			it {should have_content(m1.content)}
			it {should have_content(m2.content)}
			it {should have_content(user.microposts.count)}
		end
	end
	describe "signup page" do
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
	describe "edit page" do
		let(:user) {FactoryGirl.create(:user)}
		before do
			sign_in(user)
			visit edit_user_path(user)
		end

		describe "page" do
			it {should have_content("Update your profile")}
			it {should have_title("Edit user")}
			it {should have_link('change', href:'http://gravatar.com/emails')}
		end
		describe "with invalid information" do
			before {click_button "save changes"}
			it {should have_content('error')}
		end
		describe "with valid information" do
			before do
				fill_in "Name", with: "Tesla"
				fill_in "Email", with: "tesla@tesla.com"
				fill_in "Password", with: "fasterfaster"
				fill_in "Confirmation", with: "fasterfaster"
				click_button "save changes"
			end
			it {should have_title("Tesla")}
			it {should have_content("Tesla")}
			it {should have_content('tesla@tesla.com')}
			it {should_not have_content('user@example.com')}
			it {should have_selector('div.alert.alert-success')}
			specify { expect(user.reload.name).to eq "Tesla"}
		end
	end

	describe "following/followers" do
		let(:user) {FactoryGirl.create(:user)}
		let(:other_user) {FactoryGirl.create(:user)}
		before {user.follow!(other_user)}
		describe "followed users" do
			before {
				sign_in user
				visit following_user_path(user)
			}
			it {should have_title(full_title("Following"))}
			it {should have_selector('h3', text: 'Following')}
			it {should have_link(other_user.name, href: user_path(other_user))}
		end
	end

	describe "follow/unfollow button" do
		let(:user) {FactoryGirl.create(:user)}
		let(:other_user) {FactoryGirl.create(:user)}
		before {sign_in user}
		
		describe "follow button" do
			before {visit user_path(other_user)}
			it {should have_button("Follow")}
			it "should +1 followed users count" do 
				expect {click_button 'Follow'}.to change(user.followed_users, :count).by(1)
			end
			it "should +1 follower count" do
				expect {click_button 'Follow'}.to change(other_user.followers, :count).by(1)
			end
			describe "should have 'Unfollow' button after click" do
				before {click_button 'Follow'}
				it {should have_xpath("//input[@value='Unfollow']")}
			end
		end

		describe "unfollow button" do
			before {
				visit user_path(other_user)
				click_button "Follow"
			}
			it "should -1 followers count" do
				expect {click_button "Unfollow"}.to change(other_user.followers, :count).by(-1)
				#expect {click_button "Unfollow"}.to change(other_user.followers.count).by(-1) doesn't work... it is expecting a symbol after the comma. 
			end

			it "should -1 followed users count" do
				expect {click_button "Unfollow"}.to change(user.followed_users, :count).by(-1)
			end
			describe "should have 'Follow' button after click" do
				before {click_button 'Unfollow'}
				it {should have_xpath("//input[@value='Follow']")}
			end
		end

	end

end
