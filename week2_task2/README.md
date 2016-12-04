# Capybara the animal

It is an online simulation. You can play with it. It can walk, swim, sound. After long playng
it can starve and hungry. Before you can play with her again, feed her and give her sleep.

## Installation
Installation is pretty simple. You can run a simple command.
```sh
gem install capybara_animal
```
or add it to your Gemfile.
```ruby
gem 'capybara_animal'
```
Remember to make a command after it.
```ruby
bundle install
```

## Usage
As I aforementioned earlier, you can play with a capybara. First of all, create it.
```ruby
capybara = Capybara.new
```
So let's walk with her.
```ruby
capybara.walk #=> 'chlop, chlop'
```
You see how it moves funny. Common, let's go and swim with her.
```ruby
capybara.swim #=> 'Swish, swish, swish'
```
It looks very happy. Do you hear its sound?
```ruby
capybara.sound #=> "clicking.. grunting.. squealing..."
```
After all of these activities, it seems to me it a little tired and hungry.
We feed it and give sleep.
```ruby
capybara.eat #=> 'yammi food'
capybara.sleep #=> 'Hrreeh, Hrreeh...'
```
So you are met with her. Take care of it and it make you happy for 12 years approximately.

## License

MIT
