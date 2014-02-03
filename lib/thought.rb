require 'bdb'

class Thought
	@@env = Bdb::Env.new(0)

	ENV_FLAGS =  Bdb::DB_CREATE |    # Create the environment if it does not already exist.
							 Bdb::DB_INIT_TXN  | # Initialize transactions
							 Bdb::DB_INIT_LOCK | # Initialize locking.
							 Bdb::DB_INIT_LOG  | # Initialize logging
							 Bdb::DB_INIT_MPOOL  # Initialize the in-memory cache.

	@@env.open(File.join(File.dirname(__FILE__), '../db'), ENV_FLAGS, 0);
	def self.connection
		@@db ||= begin
			db = @@env.db
			db.open(nil, 'thoughts.db', nil, Bdb::Db::BTREE, Bdb::DB_CREATE | Bdb::DB_AUTO_COMMIT, 0)    
			db
		end
	end

	def self.head
		(connection.get(nil, 'head', nil, 0) || 1).to_i
	end

	def self.head=(int)
		connection.put(nil, 'head', int.to_s, 0)
	end

	def self.current
		head - 1
	end

	def self.increment
		self.head = self.head + 1
	end

	def self.insert(data, id = head)
		id = id.to_s
		txn = @@env.txn_begin(nil, 0)
		connection.put(txn, id, data.to_s, 0)
		txn.commit(0)
		self.increment
		id
	end

	def self.find(id)
		connection.get(nil, id.to_s, nil, 0)
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
