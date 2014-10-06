require 'socket'

port = 2000

if ARGV.empty?
  host = 'localhost'
  path = '/index.html'
else
  host, root, path = ARGV[0].partition('/')
  path.prepend(root)
  if root.empty? && path.empty?
    path = ARGV[1].dup
    path.prepend('/') unless path[0] == '/'
  end
end

request = "GET #{path} HTTP/1.0\r\n\r\n"

socket = TCPSocket.open(host, port)
socket.print(request)
response = socket.read
# split response at first blank line into headers and body
headers, body = response.split("\r\n\r\n", 2)
print body