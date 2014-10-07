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

def bin_or_text(file_path)
  "bin" if File.binary?(file_path)
  "text" if File.binary?(file_path)
end

def assemble_response(file_path)
  headers = []
  if File.exists?(file_path)
    # puts "Serving: #{file_path}"
    headers << "http/1.0 200 OK"
    headers << "server: localhost"
    headers << "content-type: #{bin_or_text(file_path)}/#{File.extname(file_path).delete('.')}"
    headers << "content-length: #{File.size(file_path)}\r\n\r\n"

    body = File.read(file_path)
  else
    headers << "http/1.0 404 Not Found" unless File.exists?(file_path)

    body = File.read("404_not_found.html")
  end

  return headers, body
end