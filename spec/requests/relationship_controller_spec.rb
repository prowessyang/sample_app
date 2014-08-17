require 'spec_helper'
describe RelationshipsController do
	let(:user) {FactoryGirl.create(:user)}
	let(:other_user) {FactoryGirl.create(:user)}
	before {sign_in user, no_capybara: true}

	describe "creating a relationship with Ajax" do
		it "should +1 relationship count" do
			expect do
				xhr :post, relationships_path, relationship: {followed_id: other_user.id}	
				# here the tutorial breaks. :create is changed to relationships_path to make it work
			end.to change(Relationship, :count).by(1)
		end

		it "should respond with success" do
			xhr :post, relationships_path, relationship: {followed_id: other_user.id}
			expect(response).to be_success # now is be_success a new method?
		end
	
	end

	# describe "destroying a relationship with Ajax" do
		
	# 	before { user.follow!(other_user)}
	# 	let(:relationship){user.relationships.find_by(followed_id: other_user.id)}

	# 	it "should -1 relationship count" do
	# 		count_numbers
	# 		expect do
	# 			xhr :delete, relationship_path(relationship), id: relationship.id
	# 			# relationships_path(relationship.id)
	# 		end.to change(Relationship, :count).by(-1)
	# 	end
	# 	it "should respond with success" do
	# 		xhr :delete, relationship_path(relationship.id), id: relationship.id
	# 		expect(response).to be_success
	# 	end
	# end

end

def count_numbers
	puts "Relationship count: #{Relationship.count}"
	puts "User Count: #{User.count}"
end