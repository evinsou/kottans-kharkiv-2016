require 'spec_helper'

set :environment, :test

describe 'Self Destruction Message Service' do  
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  it 'loads the home page' do
    get '/'
    expect(last_response.body).to include('Welcome, you can add a new message')
  end

  it 'loads the new message page' do
    get '/messages/new'
    expect(last_response.body).to include('Add New Message')
  end

  context 'GET /messages/link' do
    let(:message) { FactoryGirl.create(:encrypted_message, token: '123456') }

    it 'loads the page with a message link' do
      allow(Message).to receive(:find_by) { message }
      get '/messages/link'
      expect(last_response.body).to include('The link is to the message')
    end
  end

  context 'GET /messages/:token' do
    context 'for amount of time' do
      let(:message) do 
        FactoryGirl.create(:encrypted_message, {token: '123456'})
      end

      it 'loads the show message page when time is less than permitted' do
        Timecop.travel(Time.now + 115.minutes)
        allow(Message).to receive(:find_by) { message }
        get '/messages/:token', token: '123456'
        expect(last_response).to be_ok
      end

      it 'does not load the show message page when time is expired' do
        Timecop.travel(Time.now + 120.minutes)
        allow(Message).to receive(:find_by) { message }
        get '/messages/:token', token: '123456'
        expect(last_response).to be_ok
      end
    end

    context 'for number of visits' do
      let(:message_hash) { { param_type: 'visit', token: '123456' } }
      let(:message) do
        FactoryGirl.create(:encrypted_message, message_hash)
      end

      it 'loads the show message page when number of visits is permitted' do
        allow(Message).to receive(:find_by) { message }
        get '/messages/:token', token: '123456'
        expect(last_response).to be_ok
      end

      it 'does not load the show message page '\
         'when a number of visits is ended' do
        message_hash.merge!({param_amount: '0'})
        allow(Message).to receive(:find_by) { message }
        get '/messages/:token', token: '123456'
        expect(last_response.status).to eq(302)
      end
    end
  end

  context 'POST /messages' do
    context 'with valid attributes' do
      before { post '/messages', message: FactoryGirl.attributes_for(:message) }

      it 'creates the message' do
        expect(Message.count).to eq(1)
      end

      it 'redirects to the "show" action for the new vehicle' do
        expect(last_response.header['Location']).
          to eq("http://example.org/messages/link")
      end
    end

    context 'with invalid attributes' do
      before do
        message_attrs = FactoryGirl.attributes_for(:message, param_type: nil)
        post '/messages', message: message_attrs
      end

      it 'does not create the message' do
        expect(Message.count).to eq(0)
      end

      it 're-renders the "new" view' do
        expect(last_response.body).to include('Add New Message')
      end
    end
  end
end

describe Message do
  it 'is a valid message' do
    expect(FactoryGirl.build(:message)).to be_valid
  end

  it 'is an invalid message when there is no body' do
    expect(FactoryGirl.build(:message, body: nil)).to be_invalid
  end

  it 'is an invalid message when there is no link' do
    expect(FactoryGirl.build(:message, link: nil)).to be_invalid
  end

  it 'is an invalid message when there is no token' do
    expect(FactoryGirl.build(:message, token: nil)).to be_invalid
  end

  it 'is an invalid message when there is no param type' do
    expect(FactoryGirl.build(:message, param_type: nil)).to be_invalid
  end

  it 'is an invalid message when there is no param amount' do
    expect(FactoryGirl.build(:message, param_amount: nil)).to be_invalid
  end
end
