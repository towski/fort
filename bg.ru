require "rubygems"
require "sinatra"
require "sinatra/base"
require 'debugger'
require "./application"

#require File.expand_path '../bg.rb', __FILE__

class MyApp < Sinatra::Base
	get '/job' do
		puts "here"
	  env['rack.hijack'].call
		io = env['rack.hijack_io']
    io.write("\r\n")
		io.flush
		io.close
		sleep 2
		[200]
	end
end

run MyApp
