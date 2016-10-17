require 'sinatra'
require 'sinatra/flash'
require 'sinatra/activerecord'
require './environments'
require 'securerandom'
require 'aescrypt'
require 'securerandom'

enable :sessions
set :session_secret, '*74&gl(^d9$m'

OPTIONS = { 'visit' => 'Remove after number of visits:',  
            'hour' => 'Remove in hours:' }

class Message < ActiveRecord::Base
  validates :body, :link, :token, :param_type, :param_amount, presence: true
end

get '/' do
  @flash_alert = flash[:alert]
  erb :"messages/index"
end

get '/messages/new' do
  @message = Message.new
  erb :"messages/new"
end

get '/messages/link' do
  @message = Message.find_by(token: flash[:token])
  erb :"messages/link"
end

post '/messages' do
  if message_body = params[:message][:body]
    params[:message][:body] = AESCrypt.encrypt(message_body, '')
  end
  params[:message][:token] = SecureRandom.hex(8)
  params[:message][:link] = compose_link(request, params[:message][:token])

  @message = Message.new(params[:message])

  if @message.save
    flash[:token] = @message.token
    redirect '/messages/link'
  else
    erb :"messages/new"
  end
end

get '/messages/:token' do
  @message = Message.find_by(token: params[:token])
  unless accessible_message?
    flash[:alert] = 'The message has been removed.'
    redirect '/'
  end

  @message.body = AESCrypt.decrypt(@message.body, '')
  erb :"messages/show"
end

helpers do
  include Rack::Utils
  alias_method :h, :escape_html
end

private
  def compose_link(request, url_token)
    "#{request.base_url}#{request.fullpath}/#{url_token}"
  end

  def accessible_message?
    case @message.param_type
    when 'hour'
      (Time.now - @message.created_at)/3600 < @message.param_amount
    when 'visit'
      result = @message.param_amount > 0
      @message.param_amount -= 1
      @message.save
      result
    end
  end
