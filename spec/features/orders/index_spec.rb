require 'rails_helper'

describe 'the orders page', type: :feature do
  let(:user) { create :user }
  let!(:orders) { create_list :order, 3 }

  it 'shows the order page' do
    visit(orders_url)
    within('.new_user') do
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
    end
    click_button 'Log in'

    expect(page).to have_css 'form.new_order_search_form'
    expect(page).to have_css 'h1', text: 'Orders (3)'
    expect(page).to have_css 'a', text: 'Logout'
  end
end
