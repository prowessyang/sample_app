require 'spec_helper'
describe 'microposts' do
	subject { page }
	let(:user) {FactoryGirl.create(:user)}
	before {sign_in user}

	describe 'creating a new post' do
		before { visit root_path }
		
		describe "with invalid info" do
			
			it "should avoid empty page" do
				expect{ click_button 'Post' }.not_to change(Micropost, :count)
			end
			describe "should show error message" do

				before {click_button "Post"}
				it {should have_content("error")}
			end
		end
		
		describe "with valid info" do
			before {fill_in "micropost_content", with: "blablabal"}
			it "should create a new post" do
				expect{ click_button 'Post'}.to change(Micropost, :count).by(1)
			end
		end
	end

	describe "deleting a post" do
		let!(:micropost) { FactoryGirl.create(:micropost, user:user, content:"blablabla")}
		before {
			#FactoryGirl.create(:micropost, user:user, content:"clauksde")
			visit user_path(user)
		}
		it "should be able to delete the post" do
			expect {click_link('delete')}.to change(Micropost, :count).by(-1)
		end
	end

end