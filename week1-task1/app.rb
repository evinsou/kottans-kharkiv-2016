require 'sinatra/base'
require 'sinatra/flash'
require 'sinatra/activerecord'
require 'securerandom'
require 'aescrypt'
require 'byebug'

class Message < ActiveRecord::Base
  validates :body, :link, :token, :param_type, :param_amount, presence: true
end

class Sdms < Sinatra::Base
  enable :sessions
  register Sinatra::Flash
  set :root, File.dirname(__FILE__)
  set :session_secret, '*74&gl(^d9$m'

  OPTIONS = { 'visit' => 'Remove after number of visits:',  
              'hour' => 'Remove in hours:' }

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
    message_hash = MessageProcessor.new(params[:message], request).preprocess
    @message = Message.new(message_hash)

    if @message.save
      flash[:token] = @message.token
      redirect '/messages/link'
    else
      erb :"messages/new"
    end
  end

  get '/messages/:token' do
    @message = Message.find_by(token: params[:token])
    unless AccessChecker.new(@message).accessible_message?
      flash[:alert] = 'The message has been removed.'
      redirect '/'
    end
    if @message.param_type == 'visit'
      @message.param_amount -= 1
      @message.save
    end

    @message.body = BodyCrypter.new(text: @message.body).decrypt
    erb :"messages/show"
  end

  helpers do
    include Rack::Utils
    alias_method :h, :escape_html
  end

end

require './environments'

class MessageProcessor
  attr_reader :message_hash, :request

  def initialize(message_hash, request)
    @message_hash = message_hash
    @request = request
  end

  def preprocess
    res_hash = {}

    if body = message_hash[:body]
      res_hash[:body] = BodyCrypter.new(text: body).encrypt
    end
    res_hash[:token] = SecureRandom.hex(8)
    res_hash[:link] = compose_link(request, res_hash[:token])

    message_hash.merge(res_hash)
  end

  private
    def compose_link(request, url_token)
      "#{request.base_url}#{request.fullpath}/#{url_token}"
    end
end

class BodyCrypter
  def initialize(text: body, passwd: '')
    @text = text
    @passwd = passwd
  end

  def encrypt
    AESCrypt.encrypt(@text, @passwd)
  end

  def decrypt
    AESCrypt.decrypt(@text, @passwd)
  end
end

class AccessChecker
  def initialize(message)
    @checks = [CheckerByHours.new(message), CheckerByVisits.new(message)]
  end

  def proper_type?(check_type, message)
    check_type == message.param_type
  end

  def accessible_message?
    @checks.any? { |c| c.check_succeed? }
  end
end

class CheckerByHours < AccessChecker
  def initialize(message)
    @message = message
    @check_type = 'hour'
  end

  def check_succeed?
    return unless proper_type?(@check_type, @message)

    (Time.now - @message.created_at)/3600 < @message.param_amount
  end
end

class CheckerByVisits < AccessChecker
  def initialize(message)
    @message = message
    @check_type = 'visit'
  end

  def check_succeed?
    return unless proper_type?(@check_type, @message)

    @message.param_amount > 0
  end
end
