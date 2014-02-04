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
	def inaccessible
		check = env['HTTP_X_FORWARDED_FOR'] != "127.0.0.1"
		if check
			redirect to('http://towski.no-ip.biz/')
		end
		check
	end

	get '/' do
		exit
	end

  get '/fort/?' do
		s = Sender.new
		result = s.get
		puts result
  end

	get '/fort/thoughts' do
		Thought.last(10).to_json
	end

	post '/fort/thoughts/:number' do
		thought = Thought.find params[:number]
		thought.update_attribute :body, params[:body]
		redirect to('http://localhost')
	end

	post '/fort/thoughts' do
		return if inaccessible
		hash = env['rack.request.form_hash']
		hash['time'] = Time.now
		# need a lock for this
		hash['id'] = Thought.id
		Thought.insert hash
		redirect to('http://localhost/')
	end
end
