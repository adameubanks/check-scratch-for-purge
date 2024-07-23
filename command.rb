require 'open3'

class Command
  def to_s
    #"find /scratch/$USER -type f -atime +90 -ctime +90 -mtime +90 -print"
    "ls"
  end

  def parse(output)
    table_rows = []
    lines = output.strip.split("\n")
  
    lines.each do |line|
      table_rows << line
    end

    table_rows
  end

  def exec
    processes, error = [], nil
  
    stdout, stderr, status = Open3.capture3(to_s)
    stdout.force_encoding('UTF-8')
    
    output = stdout + stderr
  
    processes = parse(output) if status.success?
  
    [processes, error]
  end
end
