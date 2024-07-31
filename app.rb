require 'sinatra'
require 'erubi'
require './command'

set :erb, :escape_html => true

purge_command = "find /scratch/$USER -type f -atime +90 -ctime +90 -mtime +90 -print"
# purge_command = "ls"

if development?
  require 'sinatra/reloader'
  also_reload './command.rb'
end

get '/' do
  command = Command.new
  output, error = command.exec(purge_command)
  @output = command.parse(output)
  @error = error
  erb :index
end

get '/downloadToScratch' do
  command = Command.new
  output, error = command.exec("#{purge_command} > /scratch/$USER/scratchFilesToBePurged.txt")
  @output = command.parse(output)
  @error = error
  @message = "List of files to be purged has been downloaded to your /scratch directory as scratchFilesToBePurged.txt"
  erb :index, locals: { output: @output, error: @error, message: @message }
end

get '/downloadToHome' do
  command = Command.new
  output, error = command.exec("#{purge_command} > /home/$USER/scratchFilesToBePurged.txt")
  @output = command.parse(output)
  @error = error
  @message = "List of files to be purged has been downloaded to your /home directory as scratchFilesToBePurged.txt"
  erb :index, locals: { output: @output, error: @error, message: @message }
end