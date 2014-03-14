$TEST_DB = true
require_relative 'test_helper'
require 'debugger'

class Attempt < Model
end

class Event < Model
end

begin
	def test_thought
		new_id = Attempt.head
		thought = Attempt.new(body: 'hey')
		thought.save
		raise unless new_id == thought.id
		raise unless new_id + 1 == Attempt.head
	end

	def test_find
		thought = Attempt.new(body: 'hey')
		thought.save
		same_thought = Attempt.find thought.id
		raise unless same_thought.id == thought.id
		same_thought.update(body: 'now')
		same_thought = Attempt.find thought.id
		raise unless same_thought.body == "now"
		same_thought.update_attribute :body, 'hey'
		next_thought = Attempt.find thought.id
		raise unless next_thought.body == "hey"
		Attempt.last(10).to_json
	end

	def test_two_models
		event = Event.find(Event.head)
		raise unless event == nil
		event = Event.new(body: 'hey')
		event.save
		find_event = Event.find(event.id)
		raise if find_event == nil
		event.destroy
		find_event = Event.find(event.id)
		raise if find_event != nil
	end

	test_thought
	test_find
	test_two_models
	puts "No errors!"
rescue Exception => e
	pp e.backtrace
	puts "\n #{e.inspect}"
end

