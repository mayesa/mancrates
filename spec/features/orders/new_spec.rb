require 'rails_helper'

describe 'the new order page', type: :feature do
  let(:user) { create :user }
  let!(:product) { create :product }

  it 'shows the new order page' do
    visit(new_order_url)
    within('.new_order') do
      fill_in 'Customer name', with: 'John Doe'
      fill_in 'Adress', with: 'Fake Street'
      fill_in 'Zip code', with: '1234'
    end
    click_button 'Create Order'

    visit(orders_url)
    # User not signed in, so is asked to be logged in to access orders
    within('.new_user') do
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
    end
    click_button 'Log in'

    expect(page).to have_css 'td', text: 'John Doe'
  end
end
