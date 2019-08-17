require 'rails_helper'

describe 'First visit' do
  before do
    driven_by :selenium_chrome_headless
  end
  it 'redirects to pages#index because there are no pages' do
    visit '/qbrick'
    expect(page).to have_content 'Welcome to qBrick'
  end
end
