require 'socket'

hostname = 'localhost'
port = 2000

socket = TCPSocket.open(hostname, port)

socket.print("Hello World!\r\n")

while line = socket.gets
  puts line.chop
end
socket.close