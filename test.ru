require 'rack'
require 'debugger'

app = lambda do |env|
	debugger
  # Fully hijack the client socket.
  env['rack.hijack'].call
  io = env['rack.hijack_io']
  begin
    io.write("Status: 200\r\n")
    io.write("Connection: close\r\n")
    io.write("Content-Type: text/plain\r\n")
    io.write("\r\n")
    10.times do |i|
      io.write("Line #{i + 1}!\n")
      io.flush
      sleep 1
    end
  ensure
    io.close
  end
end

run app
