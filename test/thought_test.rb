$TEST_DB = true
require_relative 'test_helper'
require_relative '../lib/thought'
require 'debugger'

begin
	def test_thought
		new_id = Thought.head
		thought = Thought.new(body: 'hey')
		thought.save
		raise unless new_id == thought.id
		raise unless new_id + 1 == Thought.head
	end

	def test_find
		thought = Thought.new(body: 'hey')
		thought.save
		same_thought = Thought.find thought.id
		raise unless same_thought.id == thought.id
		same_thought.update(body: 'now')
		same_thought = Thought.find thought.id
		raise unless same_thought.body == "now"
		same_thought.update_attribute :body, 'hey'
		next_thought = Thought.find thought.id
		raise unless next_thought.body == "hey"
		Thought.last(10).to_json
	end
	test_thought
	test_find
	puts "No errors!"
rescue Exception => e
	puts "#{e.inspect}"
	puts "#{e.backtrace}"
end

