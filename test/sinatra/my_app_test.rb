ENV['RACK_ENV'] = 'test'

gem 'minitest'
#require 'minitest/autorun'
require 'minitest/unit'
require 'rack/test'
require 'debugger'
require './myapp.rb'

class MyAppTest < MiniTest::Test
  include Rack::Test::Methods

  def app
		MyApp
  end

  def test_it_says_hello_world
		Thought.new :body => "thinking..."
    get '/fort/thoughts'
    assert last_response.ok?
		assert true
  end
end

MiniTest.run
Model.db.close
Model.env.close
