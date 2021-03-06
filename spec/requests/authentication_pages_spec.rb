require 'spec_helper'

describe "Authentication" do

	subject { page }
  
  describe "signin page" do
  	before {visit signin_path}
    it {should have_title('Sign in')}
    it {should have_title('Sign in')}

    describe "with invalid information" do
    	before {click_button "Sign in"}
    	it {should have_title('Sign in')}
    	it {should have_selector('div.alert.alert-error')}
    	describe "after visiting another page" do
    		before {click_link "Home"} # It's a link not button!
    		it {should_not have_selector('div.alert.alert-error')}
    	end
    end
    describe "with valid information" do
    	let(:user) {FactoryGirl.create(:user)}
    	before do
    		fill_in "Email", with: user.email.upcase
    		fill_in "Password", with: user.password
    		click_button "Sign in"
    	end
    	it {should have_title(user.name)}
    	it {should have_link('Profile', href:user_path(user))}
      
      it {should have_link('Settings', href:edit_user_path(user))} # edit_user_path is one of the named routes in rails. Default by system.
    	it {should have_link('Sign out', href:signout_path)}
      it {should have_link('Users', href:users_path)}
    	it {should_not have_link('Sign_in', href:signin_path)}

    	describe "followed by signout" do
    		before {click_link 'Sign out'}
    		it {should have_link 'Sign in'}
    	end
    end
    
    describe "authorization" do
      
      describe "for non-signed-in users" do
        let(:user) {FactoryGirl.create(:user)}
        describe "in the users controller" do
          
          describe "visiting the edit page" do
            before {visit edit_user_path(user)}
            it {should have_title('Sign in')}
            # specify{expect(response).to redirect_to('signin_path')}
          end

          describe "submitting to the update action" do
            before {patch user_path(user)} # test the http patch request response specifically 
            specify {expect(response).to redirect_to(signin_path)}
          end

          describe "test redirect to desired destination page" do
              before do
                visit edit_user_path(user)
                fill_in "Email", with: user.email
                fill_in "Password", with: user.password
                click_button "Sign in"
              end 
              specify{expect(page).to have_title("Edit user")} 
          end

          describe "visiting the user index" do
            before {visit users_path}
            it {should have_content('Sign in')}
          end

          describe "in the Micropost controller" do
            describe "submitting to the create action" do
              before {post microposts_path}
              specify{ expect(response).to redirect_to(signin_path)}
            end
            describe "submitting to the destory action" do
              before {delete micropost_path(FactoryGirl.create(:micropost))}
              specify {expect(response).to redirect_to(signin_path)}
            end
          end

          describe "visiting the following page" do
            before {visit following_user_path(user)}
            it {should have_title("Sign in")}
          end
          
          describe "visiting the follower page" do
            before {visit followers_user_path(user)}
            it {should have_title("Sign in")}
          end

        end
        
        describe "in the relationship controller" do
          
          describe "submitting create action" do
            before {post relationships_path}
            specify {expect(response).to redirect_to(signin_path)}
          end
          describe "submitting destory action" do
            before {delete relationship_path(1)} 
            # The number "1" is to avoid creating relationship object; There is no relationship(1) object however. It should redirect before it is even required.
            specify {expect(response).to redirect_to(signin_path)}

          end

        end

      end

      describe "as wrong user" do
        let (:user) {FactoryGirl.create(:user)}
        let (:wrong_user) {FactoryGirl.create(:user, email: "wrong@example.com")}
        before {sign_in user, no_capybara: true}
        describe "submitting a GET request to the Users#edit action" do
            before {get edit_user_path(wrong_user)}
            specify {expect(response).to redirect_to(root_url)}
        end
        describe "submitting a patch request to Users#update action" do
            before {patch user_path(wrong_user)}
            specify { expect(response).to redirect_to(root_url)}
        end
      end
    end
  
  end
end
