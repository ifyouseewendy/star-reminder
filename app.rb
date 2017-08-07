# frozen_string_literal: true
require "sinatra/base"

class MyApp < Sinatra::Base
  set :public_folder, File.dirname(__FILE__) + "/dist"

  get "/" do
    erb :index, layout: :layout
  end
end
