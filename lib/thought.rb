require 'sbdb'

DB_INIT_CDB = 64

class Thought
	@@env = SBDB::Env.new File.join(File.dirname(__FILE__), '../db'), SBDB::CREATE | SBDB::Env::INIT_MPOOL | DB_INIT_CDB

	def self.env
		@@env
	end

	def self.db
		@@db ||= env.btree 'thoughts.db', :flags => SBDB::CREATE
	end

	def self.head
		(db['head'] || 1).to_i
	end

	def self.head=(int)
		db['head'] = int.to_s
	end

	def self.current
		head - 1
	end

	def self.increment
		self.head = self.head + 1
	end 

	def self.insert(data, id = head)
		db[id] = data
		self.increment
		id
	end

	def self.delete(id)
		db[id.to_s] = nil
	end

	def self.find(id)
		db[id.to_s]
	end

	def self.last(int = nil)
		if int
			int.times.map do |i|
				find((head - 1) - i)
			end.compact
		else
			find(current)
		end
	end
end

Signal.trap 'EXIT', Thought.env.method(:close)
Signal.trap 'EXIT', Thought.db.method(:close)
