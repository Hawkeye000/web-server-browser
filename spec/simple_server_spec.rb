require_relative '../lib/simple_socket_helper.rb'

describe "Simple Server" do 

  it "should know which HTTP request it receives" do 
    request_methods = []
    HTTP_METHODS.each do |method|
      request_methods << identify_http_method("#{method} /index.html HTTP/1.0\r\n\r\n")
    end
    expect(request_methods).to eq(HTTP_METHODS)
  end

  it "should be able to identify the resource in a GET request" do
    expect(identify_resource("GET /index.html HTTP/1.0\r\n\r\n")).to eq("/index.html")
  end

  it "should serve 404_not_found.html if the resource is invalid" do
    file_path = identify_resource("GET /fake_path.html HTTP/1.0\r\n\r\n")
    headers, body = assemble_response(file_path)
    expect(body).to eq(File.read("404_not_found.html"))
  end

end