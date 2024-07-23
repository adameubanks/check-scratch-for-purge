require 'sinatra'
require 'erubi'
require './command'

set :erb, :escape_html => true

if development?
  require 'sinatra/reloader'
  also_reload './command.rb'
end

# Define a route at the root '/' of the app.
get '/' do
  command = Command.new
  processes, error = command.exec

  erb :index, locals: { processes: processes, error: error }
end

post '/save_to_scratch' do
  content = params[:content]
  File.open('/scratch/output.txt', 'w') do |file|
    file.write(content)
  end
  render plain: "File saved successfully"
end

post '/save_to_home' do
  content = params[:content]
  File.open('/home/output.txt', 'w') do |file|
    file.write(content)
  end
  render plain: "File saved successfully"
end