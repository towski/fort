require 'socket'

begin
  sock = TCPSocket.new 'towski.us', 4444
  sock.write("hey")
  remote_host, remote_port = sock.read.split(":")
  puts "readed #{remote_host}"
  sock.close
rescue => e
  puts e.inspect
end

# Punches hole in firewall
punch = UDPSocket.new
punch.bind('', remote_port)
punch.send('', 0, remote_host, remote_port)
punch.close

# Bind for receiving
udp_in = UDPSocket.new
udp_in.bind('0.0.0.0', 6311)
puts "Binding to local port 6311"
@start = false

loop do
  # Receive data or time out after 5 seconds
  if IO.select([udp_in], nil, nil, 10)
    data = udp_in.recvfrom(1024)
    remote_port = data[1][1]
    remote_addr = data[1][3]
    puts "Response from #{remote_addr}:#{remote_port} is #{data[0]}"
    if data[0] == "got"
      puts 'got handy'
      @start = true
    end
    if @start
      puts 'sending handy'
      udp_in.send("handy", 0, remote_host, remote_port)
    else
      puts "Sending a little something.."
      udp_in.send(Time.now.to_s, 0, remote_host, remote_port)
    end
  else
    #if we time out, we know the other guy has started
    puts "actually timed out"
    i = 0
    loop do
      udp_in.send(Time.now.to_s, 0, remote_host, remote_port)
      puts "sent data #{i += 1}"
      exit if i > 10
    end if @start
  end
end
