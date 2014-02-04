# set path to app that will be used to configure unicorn, 
# note the trailing slash in this example
@dir = "/home/towski/code/fort/"

if ENV["RACK_ENV"] == "development"
  worker_processes 16
	timeout 300
else
	worker_processes 16
	timeout 30
end
working_directory @dir


# Specify path to socket unicorn listens to, 
# we will use this in our nginx.conf later
listen "#{@dir}tmp/sockets/background_unicorn.sock", :backlog => 64

# Set process id path
pid "#{@dir}tmp/pids/background_unicorn.pid"

# Set log file paths
#stderr_path "#{@dir}log/background_unicorn.stderr.log"
#stdout_path "#{@dir}log/background_unicorn.stdout.log"

after_fork do |server, worker|
  # per-process listener ports for debugging/admin/migrations
  addr = "127.0.0.1:#{9393 + worker.nr}"
  server.listen(addr, :tries => -1, :delay => 5, :tcp_nopush => true)
end
