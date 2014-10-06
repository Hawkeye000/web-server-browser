require 'socket'
require 'ptools'
require_relative 'simple_server_helper.rb'

port = 2000

server = TCPServer.open(port)
loop { 
  client = server.accept
  lines = []
  headers = []
  body = ""

  while line = client.gets and line !~ /^\s*$/
    lines << line.chomp
  end

  puts "Received: #{lines.join("\n")}"

  if identify_http_method(lines[0]) == "GET"
    file_path = identify_resource(lines[0])
    file_path[0] = "" # remove the leading root indicator
    headers, body = assemble_response(file_path)
  else
    body = File.read("404_not_found.html")
  end

  client.puts headers
  client.puts body

  client.close  
}

