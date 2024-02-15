require 'sinatra'
require 'json'

get '/' do
  content_type :json
  { message: "Hello from Sinatra!" }.to_json
end

get '/fail' do
  raise "Oops! Server is down!"
end

not_found do
  content_type :json
  status 404
  { error: "Route not found" }.to_json
end

error do
  content_type :json
  status 500
  { error: "Internal server error" }.to_json
end
