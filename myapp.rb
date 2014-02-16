# myapp.rb
require 'sinatra'
require 'sinatra/cross_origin'
require 'open-uri'
require 'gon-sinatra'

configure do
  enable :cross_origin
end

get '/cross_origin' do
  cross_origin
  "This is available to cross-origin javascripts"
end

# rake cron job:  http://stackoverflow.com/questions/3875704/how-to-run-a-cron-job-in-heroku-with-a-sinatra-app

Sinatra::register Gon::Sinatra
# set :allow_origin, :any
# set :allow_methods, [:get, :post, :options]
# set :allow_credentials, true
# set :max_age, "1728000"
# set :expose_headers, ['Content-Type']


get '/' do
		#response['Access-Control-Allow-Origin'] = 'http://www.google.com/alerts/feeds/01662123773360489091/17860385030804394525'
  # cross_origin :allow_origin => 'http://www.google.com/alerts/feeds/01662123773360489091/17860385030804394525',
  #   :allow_methods => [:get],
  #   :allow_credentials => false,
  #   :max_age => "60"
    @url = "http://www.google.com/alerts/feeds/01662123773360489091/17860385030804394525"
    @data  = open('http://www.google.com/alerts/feeds/01662123773360489091/17860385030804394525') {|f| f.read }

    gon.url = @url
    gon.data = @data
    File.open("public/xml/data.xml", "w") { |io|  
    	io.write(@data)
    }

  erb :parser
end
