require_relative '../lib/simple_server_helper.rb'

describe "Simple Server" do 

  it "should know which HTTP request it receives" do 
    request_methods = []
    HTTP_METHODS.each do |method|
      request_methods << identify_http_method("#{method} /index.html HTTP/1.0\r\n\r\n")
    end
    expect(request_methods == HTTP_METHODS)
  end

end