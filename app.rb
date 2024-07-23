require 'sinatra'
require 'erubi'
require './command'

set :erb, :escape_html => true

if development?
  require 'sinatra/reloader'
  also_reload './command.rb'
end

# Define a route at the root '/' of the app.
#find /scratch/$USER -type f -atime +90 -ctime +90 -mtime +90 -print
get '/' do
  if params['action'] == 'downloadToScratch'
    command = Command.new
    output, error = command.exec("find /scratch/$USER -type f -atime +90 -ctime +90 -mtime +90 -print > ~/scratch/$USER/output.txt")#("ls > ~/Downloads/output.txt")
  elsif params['action'] == 'downloadToHome'
    command = Command.new
    output, error = command.exec("find /scratch/$USER -type f -atime +90 -ctime +90 -mtime +90 -print > ~/home/$USER/output.txt")#("ls > ~/Documents/output.txt")
  end
  command = Command.new
  output, error = command.exec("find /scratch/$USER -type f -atime +90 -ctime +90 -mtime +90 -print")#("ls")
  output = command.parse(output)

  erb :index, locals: { output: output, error: error }
end