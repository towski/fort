# set path to app that will be used to configure unicorn, 
# note the trailing slash in this example
@dir = "/home/towski/code/triforce/"

if ENV["RACK_ENV"] == "development"
	require 'debugger'
  worker_processes 1
	timeout 300
else
	worker_processes 2
	timeout 30
end
working_directory @dir


# Specify path to socket unicorn listens to, 
# we will use this in our nginx.conf later
listen "#{@dir}tmp/sockets/unicorn.sock", :backlog => 64

# Set process id path
pid "#{@dir}tmp/pids/unicorn.pid"

# Set log file paths
stderr_path "#{@dir}log/unicorn.stderr.log"
stdout_path "#{@dir}log/unicorn.stdout.log"

after_fork do |server, worker|
  # per-process listener ports for debugging/admin/migrations
  addr = "127.0.0.1:#{9293 + worker.nr}"
  server.listen(addr, :tries => -1, :delay => 5, :tcp_nopush => true)
end
