# frozen_string_literal: true

require 'rails_helper'

feature 'home_page' do
  scenario 'welcome message' do
    visit('/')
    expect(page).to have_content('Welcome')
  end
end
