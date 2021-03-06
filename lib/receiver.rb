require 'socket'
require 'json'
require_relative '../application'
CRLF = "\r\n"

@index = 0 
@timeouts = 0
@pictures = []

def receive
  begin
    puts "What should we do?:"
    command = gets.strip
    sock = TCPSocket.new 'ec2-54-196-239-114.compute-1.amazonaws.com', 4444 #'towski.us', 4444
    sock.write({type: command}.to_json)
    result = sock.read
    response = JSON.parse(result)
    puts response
    remote_host, remote_port = response['host'].split(":")
    puts "readed #{remote_host}"
    sock.close
  rescue => e
    puts e.inspect
    return
  end

  return if remote_host == "76.14.75.67"

  puts remote_host
  remote_port = 6311

  # Punches hole in firewall
  punch = UDPSocket.new
  punch.bind('', remote_port)
  punch.send('', 0, remote_host, remote_port)
  punch.close

  # Bind for receiving
  udp_in = UDPSocket.new 
  udp_in.bind('0.0.0.0', 6311) 
  puts "Binding to local port 6311"
  @got = false
  @start = false

  loop do
    # Receive data or time out after 5 seconds
    if IO.select([udp_in], nil, nil, rand(4))
      data = udp_in.recvfrom(1024)
      remote_port = data[1][1]
      remote_addr = data[1][3]
      if data[0] == "handy"
        puts "got handshake"
        @start = true
      else
        puts "got first response"
        @got = true
      end
      i = 0
      output = ""
      timeouts = 0
      data_amount = 0
      loop do
        if IO.select([udp_in], nil, nil, 5)
          data = udp_in.recvfrom(1024)
          puts "got data #{data_amount}" if data_amount % 1000 == 0
          data_amount += 1
          next if data[0] == "handy"
          if data[0] == CRLF
            puts "got #{output.size} data"
            if command == "ls"
              @pictures = JSON.parse(output)
              puts @pictures
            else
              filename = Picture.receive(output, command.to_i)
              p = Picture.find(command.to_i)
              if p.nil?
                data = @pictures.select {|picture| picture["id"].to_i == command.to_i }.first
                p = Picture.new(data.merge('local_filename' => filename))
                p.save
              end
            end
            udp_in.close
            # handle data type
            return
          end
          output += data[0]
        else
          puts "timed out"
          timeouts += 1
          if timeouts > 10
            puts "too many time outs"
            udp_in.close
            return
          end
        end
      end if @start
    else
      puts "timeout"
      @timeout += 1
      if @timeout > 10
        udp_in.close
        return
        puts "timing out" 
      end
      if @got
        puts "sending handy"
        udp_in.send("got", 0, remote_host, remote_port)
      else
        puts "Sending a little something.."
        udp_in.send(Time.now.to_s, 0, remote_host, remote_port)
      end
    end
  end
end

loop do
  @timeout = 0
  receive
  puts "done receiving"
end
