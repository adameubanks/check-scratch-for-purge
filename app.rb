require 'sinatra'
require 'erubi'
require './command'
require 'json'

set :erb, :escape_html => true

if development?
  require 'sinatra/reloader'
  also_reload './command.rb'
end

# Define a route at the root '/' of the app.
get '/' do
  command = Command.new
  output, error = command.exec("find /scratch/$USER -type f -atime +90 -ctime +90 -mtime +90 -print")
  output = command.parse(output)
  erb :index, locals: { output: output, error: error }
end

# Define a route to handle AJAX requests.
post '/run_command' do
  request_payload = JSON.parse(request.body.read)
  action = request_payload['action']
  
  command = Command.new
  case action
  when 'downloadToScratch'
    output, error = command.exec("find /scratch/$USER -type f -atime +90 -ctime +90 -mtime +90 -print > /scratch/$USER/scratchFilesToBePurged.txt")
  when 'downloadToHome'
    output, error = command.exec("find /scratch/$USER -type f -atime +90 -ctime +90 -mtime +90 -print > /home/$USER/scratchFilesToBePurged.txt")
  else
    output, error = command.exec("find /scratch/$USER -type f -atime +90 -ctime +90 -mtime +90 -print")
  end

  output = command.parse(output)
  content_type :json
  { output: output, error: error }.to_json
end
