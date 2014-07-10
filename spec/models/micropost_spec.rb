require 'spec_helper'

describe Micropost do
  let (:user) { FactoryGirl.create(:user)}
  before {@micropost = user.microposts.build(content:"I have a big tooth")} #.create saves, .build does not save it yet. 

  subject { @micropost }

  it {should respond_to(:content)}
  it {should respond_to(:user_id)}
  describe "test relational link between user and post" do
  	it {should respond_to(:user)} # linked to user resource
  	its(:user) {should eq user}
	end
  it {should be_valid}
  	describe "when user_id is nil" do
  		before {@micropost.user_id = nil}
  		it {should_not be_valid}
  	end
    describe "with blank content" do
      before {@micropost.content = " "}
      it {should_not be_valid}
    end
    describe "with content that is too long" do
      before {@micropost.content = "a"*141}
      it {should_not be_valid}
    end
    
end
