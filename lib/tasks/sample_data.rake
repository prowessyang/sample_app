namespace :db do
	desc "Fill data with sample data"
	task populate: :environment do
		make_users
		make_microposts
		make_relationships
	end

	def make_users
		admin = User.create!(name:"The Real SlimShady",
			email:"slimshady@aftermath.com",
			password:"root8miles",
			password_confirmation:"root8miles",
			admin:true)

		99.times do |n|
			name = Faker::Name.name
			email = "simshady-#{n+1}@aftermath.com"
			password = "password"
			User.create!(name:name, 
				email:email,
				password:password,
				password_confirmation:password)
		end
	end

	def make_microposts
		users = User.all(limit:6)
		50.times {
			content = Faker::Lorem.sentence(5)
			users.each do |user|
				user.microposts.create!(content:content)
			end
		}		
	end
	def make_relationships
		users = User.all
		user = users.first
		followed_users = users[2..50]
		followers = users[3..40]
		followed_users.each {|followed| user.follow!(followed)}
		followers.each {|follower| follower.follow!(user)}
	end
end