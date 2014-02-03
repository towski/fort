require "rubygems"
require "sinatra/base"
require 'debugger'
require "json"
$:.unshift File.dirname(__FILE__) + "/lib"
require 'thought'
#Debugger.settings[:autoeval] = true
#Debugger.settings[:autolist] = 1
#Debugger.settings[:reload_source_on_change] = true

def rdebug
	Debugger.wait_connection = true
	Debugger.start_remote
	debugger
end

class MyApp < Sinatra::Base
	get '/' do
		exit
	end

  get '/triforce/?' do
		s = Sender.new
		result = s.get
		puts result
  end

	get '/triforce/head' do
		Thought.head.to_s
	end

	get '/triforce/thoughts' do
		Thought.last(10).to_json
	end

	post '/triforce/thoughts' do
		hash = env['rack.request.form_hash']
		hash['time'] = Time.now
		hash['id'] = Thought.id
		Thought.insert hash.to_json
		redirect to('http://localhost/')
	end
end
