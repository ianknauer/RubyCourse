require 'rubygems'
require 'sinatra'

set :sessions, true

get '/home' do
  erb :home
end



