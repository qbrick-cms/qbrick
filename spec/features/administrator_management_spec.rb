require 'spec_helper'

describe 'Administrator Management', type: :feature do
  let!(:root_page) { create :root_page }
  let(:admin) { create :admin }

  around(:each) do |example|
    I18n.with_locale(:en) { example.run }
  end

  before :each do
    visit qbrick.cms_pages_path
    fill_in 'E-Mail', with: admin.email
    fill_in 'Password', with: admin.password
    click_on 'Login'
  end

  describe 'admin' do
    it 'can log in with his/her credentials' do
      expect(page).to have_content 'Signed in successfully'
    end

    it 'can log out' do
      click_on 'Log out'
      visit qbrick.cms_pages_path
      expect(current_url).to eq(qbrick.new_admin_session_url)
    end

    context 'when logged in' do
      let(:new_password) { 'newAdminPW!' }

      it 'can change his/her password' do
        click_on 'Change Password'
        fill_in 'Current Password', with: admin.password
        fill_in 'Password', with: new_password
        fill_in 'Password Confirmation', with: new_password
        expect { click_on 'Update Admin' }.to change { Qbrick::Admin.find_by_email(admin.email).encrypted_password }
      end

      it 'can create a new admin user' do
        click_on 'Admins'
        click_on 'New'
        fill_in 'E-Mail', with: 'another@admin.com'
        fill_in 'Password', with: 'fancyPassword33'
        fill_in 'Password Confirmation', with: 'fancyPassword33'
        expect { click_on 'Create Admin' }.to change { Qbrick::Admin.count }
      end

      it 'can edit an admin' do
        FactoryGirl.create(:admin, email: 'somemail@admin.com')
        click_on 'Admins'
        find('tr', text: 'somemail@admin.com').find_link('Edit').click
        fill_in 'E-Mail', with: 'new_email@admin.com'
        fill_in 'Password', with: 'fancyPassword33'
        fill_in 'Password Confirmation', with: 'fancyPassword33'
        click_on 'Update Admin'
        expect(page).to have_content('new_email@admin.com')
      end

      it 'can delete an admin' do
        FactoryGirl.create(:admin, email: 'somemail@admin.com')
        click_on 'Admins'
        expect { find('tr', text: 'somemail@admin.com').find_link('Delete').click }.to change { Qbrick::Admin.count }
      end
    end
  end
end
