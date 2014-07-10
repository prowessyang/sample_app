FactoryGirl.define do
	factory :user do
		sequence(:name) {|n| "Person #{n}"}
		sequence(:email) {|n| "person_#{n}@gmail.com"}
		password "gravity"
		password_confirmation "gravity"
		# name "Junyu Yang"
		# email "prowess123@gmail.com"
		# password "gravity"
		# password_confirmation "gravity"
		
		factory :admin do #this code means "FactoryGirl.create(:admin)" will create a user that is admin
			admin true
		end
	end
	factory :micropost do
		content "I have a big tooth"
		user
	end	
end