require 'aescrypt'
require 'base64'

FactoryGirl.define do
  factory :message do
    body "What a beautiful flower"
    link 'a correct link'
    token '123456'
    param_type 'hour'
    param_amount '2'
  end

  factory :encrypted_message, parent: :message do
    body AESCrypt.encrypt("What a beautiful flower", '')
    link 'a correct link'
    token '123456'
    param_type 'hour'
    param_amount '2'
  end
end
