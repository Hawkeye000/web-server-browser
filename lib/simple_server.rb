require 'socket'

HTTP_METHODS = ["GET", "HEAD", "POST", "PUT", "DELETE", "TRACE", "CONNECT"]

def identify_http_method(initial_request_line)
  HTTP_METHODS.each do |method|
    return method if /^#{method}\s+\/\S+\s+HTTP\/1\.0\s*$\s*/ =~ initial_request_line
  end
end

def identify_resource(initial_request_line)
  initial_request_line.split.each do |http_request_part|
    return http_request_part if /^\/\w+\S*\.\w+$/ =~ http_request_part
  end
end

port = 2000

server = TCPServer.open(port)
loop { 
  client = server.accept
  lines = []

  while line = client.gets and line !~ /^\s*$/
    lines << line.chomp
  end

  puts "Received: #{lines.join("<br \>")}"

  if identify_http_method(lines[0]) == "GET"
    file_path = identify_resource(lines[0])
    response = file_path
    headers = ["http/1.0 200 OK",\
        "date: #{Time.now.ctime}",\
        "server: localhost",\
        "content-type: text/html; charset=iso-8859-1",\
        "content-length: #{response.length}\r\n\r\n"].join("\r\n")
  end

  client.puts headers
  client.puts response

  client.close  
}

