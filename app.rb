require 'sinatra'
require 'erubi'
require './command'
require 'json'

set :erb, :escape_html => true

# purge_command = "find /scratch/$USER -type f -atime +90 -ctime +90 -mtime +90 -print"
purge_command = "ls"

if development?
  require 'sinatra/reloader'
  also_reload './command.rb'
end

get '/' do
  command = Command.new
  output, error = command.exec(purge_command)
  @output = command.parse(output)
  @error = error
  erb :index, locals: { output: @output, error: @error }
end

get '/downloadToScratch' do
  command = Command.new
  output, error = command.exec("#{purge_command} > /scratch/$USER/scratchFilesToBePurged.txt")
  @output = command.parse(output)
  @error = error
  erb :index, locals: { output: @output, error: @error }
end

get '/downloadToHome' do
  command = Command.new
  output, error = command.exec("#{purge_command} > /home/$USER/scratchFilesToBePurged.txt")
  @output = command.parse(output)
  @error = error
  erb :index, locals: { output: @output, error: @error }
end

get '/downloadLocally' do
  command = Command.new
  output, error = command.exec(purge_command)
  @output = command.parse(output)
  @error = error
  content_type :json
  { output: @output.join('\n'), error: @error }.to_json
end