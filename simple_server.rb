require 'socket'

port = 2000

server = TCPServer.open(port)
loop { 
  client = server.accept
  client.puts(Time.now.ctime)
  client.puts "Closing the connection, bye!"
  client.close  
}