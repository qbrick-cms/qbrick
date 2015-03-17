require 'spec_helper'

describe 'Administrator Management', type: :feature do

  before :all do
    @page = FactoryGirl.create(:page, page_type: 'navigation', published: true, title: 'home')
  end

  after :all do
    # FIXME: Not sure why teardown is not working automagically
    @page.destroy
  end

  describe 'admin' do

    let!(:admin) { FactoryGirl.create(:admin) }
    let(:new_password) { 'newAdminPW!' }

    it 'can log in with his/her credentials' do
      visit qbrick.cms_pages_path
      fill_in 'Email', with: admin.email
      fill_in 'Password', with: admin.password
      click_on 'Log in'
      expect(page).to have_content 'Signed in successfully'
    end

    it 'can log out' do
      visit qbrick.cms_pages_path
      fill_in 'Email', with: admin.email
      fill_in 'Password', with: admin.password
      click_on 'Log in'
      click_on 'Log out'
      visit qbrick.cms_pages_path
      expect(current_url).to eq(qbrick.new_admin_session_url)
    end

    it 'can change his/her password' do
      visit qbrick.cms_pages_path
      fill_in 'Email', with: admin.email
      fill_in 'Password', with: admin.password
      click_on 'Log in'
      click_on 'Change Password'
      fill_in 'Current password', with: admin.password
      fill_in 'Password', with: new_password
      fill_in 'Password confirmation', with: new_password
      expect{ click_on 'Update Admin' }.to change{ Qbrick::Admin.find_by_email(admin.email).encrypted_password }
    end
  end

  # - create admin
  #   - mail notification?
  # - edit admin (can not edit password)
  # - delete an admin

end
