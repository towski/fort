require "rubygems"
require "sinatra"

ENV['ORM'] = 'production'

require File.expand_path '../myapp.rb', __FILE__

run MyApp
