require 'spec_helper'

describe "Static pages" do
  subject {page}

  describe "Home page" do
    before {visit root_path}
    it {should have_selector('h1',text:'Sample App')}
    it {should have_title('Ruby on Rails Tutorial Sample App')}
    it {should_not have_title('| Home')}

    describe "for signed in users" do
      let(:user) {FactoryGirl.create(:user)}
      before {
        FactoryGirl.create(:micropost, user:user, content:"abcdefg")
        FactoryGirl.create(:micropost, user:user, content:"uvwxyz")
        sign_in user
        visit root_path
      }
      it "should render users feed" do
        user.feed.each do |item|
          expect(page).to have_selector("li##{item.id}", text:item.content)
        end
      end
    end
  end

  describe "Help page" do
    before {visit help_path}
    it {should have_selector('h1', text:'Help')}
    it {should have_title(full_title('Help'))}
  end

  describe "About page" do
    before {visit about_path}
    it {should have_selector('h1', text:'About Us')}
    it {should have_title(full_title('About Us'))}
  end

  describe "Contact page" do
    before {visit contact_path}
    it {should have_selector('h1', text:'Contact')}
    it {should have_title(full_title('Contact'))}
  end

  it "should have the right link to the right layout" do
    visit root_path
    click_link "About"
    expect(page).to have_title(full_title("About"))
    click_link "Contact"
    expect(page).to have_title(full_title("Contact"))
    click_link "Help"
    expect(page).to have_title(full_title("Help"))
  end
end