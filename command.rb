require 'open3'

class Command
  def parse(output)
    table_rows = []
    lines = output.strip.split("\n")
  
    lines.each do |line|
      table_rows << line
    end

    table_rows
  end

  def exec(command)
    processes, error = [], nil
  
    stdout, stderr, status = Open3.capture3(command)
    stdout.force_encoding('UTF-8')
    
    output = stdout + stderr
  
    processes = output if status.success?
  
    [processes, error]
  end
end
