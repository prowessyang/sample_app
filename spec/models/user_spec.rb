require 'spec_helper'

describe User do
  before {@user= User.new(name:"Junyu Yang", email:"prowessyang@gmail.com", password:"telescope",password_confirmation:"telescope")}
  subject {@user}
  
  it {should respond_to(:name)}
  it {should respond_to(:email)}
  it {should respond_to(:password_digest)}
  it {should respond_to(:password)}
  it {should respond_to(:password_confirmation)}
  it {should respond_to(:remember_token)}
  it {should respond_to(:authenticate)}
  it {should respond_to(:admin)}
  it {should respond_to(:microposts)} #notice the s in the end of microposts? it's the method pulling all the microposts.
  it {should be_valid}
  it {should_not be_admin}

  describe "when set to be admin" do
    before do
      @user.save!
      @user.toggle!(:admin)
    end
    it {should be_admin} #there has to be a method for user admin?
    #yet, since admin is a boolean in db. Rails automatically figures out and add the admin? method
    
  end


  describe "when the name is empty" do
  	before {@user.name = " "}
  	it {should_not be_valid}
  end

  describe "when the email is empty" do
  	before {@user.email = " "}
  	it {should_not be_valid}
  end

  describe "when the name is more than 50 char" do
  	before {@user.name = "a" * 51}
  	it {should_not be_valid}
  end

  describe "when the email is invalid" do
  	addresses = %w[user@foo,com user_at_foo.org example.user@foo.
                     foo@bar_baz.com foo@bar+baz.com]
    addresses.each do
    	|address|
    	before {@user.email = address}
    	it {should_not be_valid}
    end
  end

  describe "when the email is valid" do
  	addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
  	addresses.each do
  		|address|
  		before {@user.email = address}
  		it {should be_valid}
  	end
  end

  describe "when email has been registered" do
  	before do
  		user_with_same_email = @user.dup
  		user_with_same_email.email = @user.email.upcase
  		user_with_same_email.save
  	end
  	it {should_not be_valid}
  end
  describe "when password is empty" do
  	before {
  		@user.password = " "
  		@user.password_confirmation = " "
  	}
  	it {should_not be_valid}
  end
  describe "when password dosen't match its confirmation" do
  	before {@user.password_confirmation = "mismatch"}
  	it {should_not be_valid}
  end
  describe "with a password that's too short" do
    before { @user.password = @user.password_confirmation = "a" * 5 }
    it { should_not be_valid }
  end

  describe "return value of authenticate method" do
    before { @user.save }
    let(:found_user) { User.find_by(email: @user.email) }

    describe "with valid password" do
      it { should eq found_user.authenticate(@user.password) }
    end

    describe "with invalid password" do
      let(:user_for_invalid_password) { found_user.authenticate("invalid") }

      it { should_not eq user_for_invalid_password }
      specify { expect(user_for_invalid_password).to be_false }
    end
  end
  describe "remember token" do
    before {@user.save}
    its(:remember_token) {should_not be_blank}
  end
  describe "microposts association" do
    before {@user.save}
    let!(:old_micropost) do
      FactoryGirl.create(:micropost, user:@user, created_at: 1.day.ago)
    end
    let!(:new_micropost) {  
      FactoryGirl.create(:micropost, user:@user, created_at: 1.hour.ago)
    }
    it "should be in the reverse time order" do
      expect(@user.microposts.to_a).to eq [new_micropost, old_micropost]
    end
    describe "status" do
      let (:unfollowed_post) {
        FactoryGirl.create(:micropost, user:FactoryGirl.create(:user))
      }
      its(:feed) {should include(new_micropost)}
      its(:feed) {should include(old_micropost)}
      its(:feed) {should_not include(unfollowed_post)}
    end
  end
end
