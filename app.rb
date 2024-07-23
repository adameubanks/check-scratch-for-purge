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
  erb :index, locals: { display_table: false, processes: nil }
end

# Define a route to handle form submission.
post '/process_form' do
  write_to_file = params['writeToFile'] == 'yes'
  file_location = params['fileLocation']

  command = Command.new
  processes, error = command.exec

  if write_to_file
    # Determine the file path based on user selection.
    file_path = file_location == 'home' ? '~/output.txt' : '/scratch/output.txt'

    # Write the output to the specified file.
    File.open(File.expand_path(file_path), 'w') do |file|
      processes.each { |line| file.puts(line) }
    end

    # Redirect back to the form page or to a success page.
    redirect '/'
  else
    # Render the index view with the command output for display in the table.
    erb :index, locals: { display_table: true, processes: processes }
  end
end