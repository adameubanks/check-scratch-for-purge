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
  output, error = command.exec("find /scratch/$USER -type f -atime +90 -ctime +90 -mtime +90 -print")
  output = command.parse(output)
  erb :index, locals: { output: output, error: error }
end

# Define a route to handle AJAX requests.
post '/run_command' do
  command = Command.new
  action = params[:action]
  case action
  when 'downloadToScratch'
    output, error = command.exec("find /scratch/$USER -type f -atime +90 -ctime +90 -mtime +90 -print > /scratch/$USER/output.txt")
  when 'downloadToHome'
    output, error = command.exec("find /scratch/$USER -type f -atime +90 -ctime +90 -mtime +90 -print > /home/$USER/output.txt")
  else
    output, error = command.exec("find /scratch/$USER -type f -atime +90 -ctime +90 -mtime +90 -print")
  end

  output = command.parse(output)
  content_type :json
  { output: output, error: error }.to_json
end