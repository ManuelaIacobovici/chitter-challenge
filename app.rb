#!/usr/bin/env ruby
require 'sinatra' 
require 'sinatra/reloader'
# require 'peep'
require './lib/db/connect.rb'
require './lib/db/create_tables.rb'
require './lib/peep.rb'

class Application < Sinatra::Base
  attr_reader :db_connection
  configure :development do
    register Sinatra::Reloader
  end

  enable :sessions
  
  configure :test, :development do
    @db_connection = Connect.initiate(:chitter)
    CreateTables.if_not_exists(@db_connection)
  end

  get '/' do 
    session[:signed_up] = false if session[:signed_up].nil?
    @signed_up = session[:signed_up]
    @peeps = Peep.all
    erb :index
  end

  post '/username_exec' do
    session[:username] = params[:username]
    session[:signed_up] = true
    redirect('/')
  end

  post '/peep_exec' do
    peep = nil
    params[:username] = session[:username].to_s if session[:signed_up] == true
    peep = Peep.add(params) if session[:signed_up] == true
    redirect('/') unless (session[:signed_up] == false) || peep.nil?
    redirect('/?error=You need to Sign up first')
  end

  run! if app_file == $0
end
