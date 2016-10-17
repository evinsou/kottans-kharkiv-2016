require 'spec_helper'
require 'capybara/rspec'

Capybara.app = Sinatra::Application
#set(:show_exceptions, false) 

describe('adding a new message', {:type => :feature}) do
  it 'selects a visit option on a new message page, creates a message and '\
     'sees a link to it' do
    visit('/')
    click_link('New Message')
    fill_in('message[body]', with: 'What a lovely day')
    type_path = "//select[@name='message[param_type]']/option"\
                "[text()='Remove after number of visits:']"
    find(:xpath, type_path).select_option
    amount_path = "//select[@name='message[param_amount]']/option[text()='2']"
    find(:xpath, amount_path).select_option
    click_button('Create a message')
    expect(page).to have_content('The link is to the message')
  end
end

describe('visiting a saved message', {:type => :feature}) do
  it 'selects a visit option on a new message page, creates a message and '\
     'sees a link to it, goes by link and sees message text' do
    visit('/')
    click_link('New Message')
    fill_in('message[body]', with: 'What a lovely day')
    type_path = "//select[@name='message[param_type]']/option"\
                "[text()='Remove in hours:']"
    find(:xpath, type_path).select_option
    amount_path = "//select[@name='message[param_amount]']/option[text()='5']"
    find(:xpath, amount_path).select_option
    click_button('Create a message')
    visit find(:xpath, "//a[contains(text(), 'message')]").text
    expect(page).to have_content('What a lovely day')
  end
end

describe('number of visits expired', {:type => :feature}) do
  it 'selects a visit option on a new message page, creates a message and '\
     'sees a link to it, visits a message page and fails to visit once more' do
    visit('/')
    click_link('New Message')
    fill_in('message[body]', with: 'What a lovely day')
    type_path = "//select[@name='message[param_type]']/option"\
                "[text()='Remove after number of visits:']"
    find(:xpath, type_path).select_option
    amount_path = "//select[@name='message[param_amount]']/option[text()='2']"
    find(:xpath, amount_path).select_option
    click_button('Create a message')
    message_link = find(:xpath, "//a[contains(text(), 'message')]").text
    3.times { visit(message_link) }
    expect(page).to have_content('Welcome, you can add a new message')
  end
end

describe('time of message existing expired', {:type => :feature}) do
  it 'selects a visit option on a new message page, creates a message and '\
     'sees a link to it, fails to visit after 5 hours' do
    visit('/')
    click_link('New Message')
    fill_in('message[body]', with: 'What a lovely day')
    type_path = "//select[@name='message[param_type]']/option"\
                "[text()='Remove in hours:']"
    find(:xpath, type_path).select_option
    amount_path = "//select[@name='message[param_amount]']/option[text()='5']"
    find(:xpath, amount_path).select_option
    click_button('Create a message')
    Timecop.travel(Time.now + 300.minutes)
    visit find(:xpath, "//a[contains(text(), 'message')]").text
    expect(page).to have_content('Welcome, you can add a new message')
  end
end
