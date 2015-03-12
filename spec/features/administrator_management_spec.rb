require 'spec_helper'

describe 'Administrator Management', type: :feature do

  it 'An administrator can log in with his credentials' do
    admin = FactoryGirl.create(:admin)
    visit qbrick.cms_pages_path
    fill_in 'Email', with: admin.email
    fill_in 'Password', with: admin.password
    click_on 'Log in'
    expect(page).to have_content 'Signed in successfully'
  end

  # - change my password
  # - create admin
  #   - mail notification?
  # - edit admin (can not edit password)
  # - delete an admin

end
