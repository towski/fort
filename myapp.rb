require "rubygems"
require "sinatra/base"
require 'debugger'
require "json"
require './application'

class MyApp < Sinatra::Base
	def inaccessible
		check = env['HTTP_X_FORWARDED_FOR'] != "127.0.0.1"
		if check
			redirect to('http://towski.no-ip.biz/')
		end
		check
	end

	get '/' do
	end

	get '/fort/jobs' do
		return if inaccessible
		job = Job.new :type => "receiver"
		rdebug
		#hash = env['rack.request.form_hash']
		job.save
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
