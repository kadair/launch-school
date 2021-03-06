require 'socket'

def parse_request(request_line)
  http_method, path_and_params, _ = request_line.split
  path, params = path_and_params.split('?')

  params = (params || "").split('&').each_with_object({}) do |param, params_table|
    key, value = param.split('=')
    params_table[key] = value
  end

  [http_method, path, params]
end

server = TCPServer.new('localhost', 3003)
loop do
  client = server.accept

  request_line = client.gets
  next if !request_line || request_line =~ /favicon/
  puts request_line # displays to terminal
  
  http_method, path, params = parse_request(request_line)

  client.puts "HTTP/1.1 200 OK\r\n\r\n" # status
  # client.puts "Content-Type: text/html\r\n\r\n" # header(s) and empty line
  # response body
  client.puts "<html>"
  client.puts "<body>"
  client.puts "<pre>"
  client.puts request_line
  client.puts http_method
  client.puts path
  client.puts params
  client.puts "</pre>"

  client.puts "<h1>Counter</h1>"

  number = params['number'].to_i
  client.puts "<p>The current number is #{number}.</p>"

  client.puts "<a href='?number=#{number + 1}'>Add one</a>"
  client.puts "<a href='?number=#{number - 1}'>Subtract one</a>"

  client.puts "</body>"
  client.puts "</html>"

  client.close
end