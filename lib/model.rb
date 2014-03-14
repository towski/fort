require 'sbdb'
require 'json'

DB_INIT_CDB = 64
if $TEST_DB
	DBDIR = File.join(File.dirname(__FILE__), '../test/db')
else
	DBDIR = File.join(File.dirname(__FILE__), '../db')
end

class Hash
	def get_with_symbol(key)
		if key.is_a?(Symbol)
			get_without_symbol(key) || get_without_symbol(key.to_s)
		else
			get_without_symbol(key)
		end
	end

	alias_method :get_without_symbol, :[]
	alias_method :[], :get_with_symbol
end

class Model
	def self.set_env
		SBDB::Env.new DBDIR, SBDB::CREATE | SBDB::Env::INIT_MPOOL | DB_INIT_CDB
	end

  class << self
    def db
      @db ||= env.btree "#{self.name.downcase}.db", :flags => SBDB::CREATE
    end
  end

  def db
    self.class.db
  end

	@@env = set_env

	def self.env
		@@env
	end


	def self.head
		(db['head'] || 1).to_i
	end

	def self.head=(int)
		db['head'] = int.to_s
	end

	def self.id
		head - 1
	end

	def self.increment
		self.head = self.head + 1
	end 

	def self.insert(data, id = head)
		if data.is_a?(Hash) 
			data["id"] = id
			db[id] = data.to_json
			self.increment
			id
		elsif data.nil?
			db[id] = nil
		end
	end

	def self.delete(id)
		db[id.to_s] = nil
	end

	def self.find(id)
		result = db[id.to_s]
		if result
			self.new JSON.parse(result)
		end
	end

	def self.last(int = nil)
		if int
			int.times.map do |i|
				find((head - 1) - i)
			end.compact
		else
			find(id)
		end
	end

	attr_accessor :id

	def initialize(params)
		@id = params[:id]
		@params = params
	end

	def update(params)
		@params = params
		self.class.insert(@params, @id)
	end

	def update_attribute(key, value)
		@params[key] = value
		self.class.insert(@params, @id)
	end

	def save
		@id ||= self.class.head
		@params["id"] = @id
		self.class.insert(@params, @id)
	end
	
	def destroy
		self.class.insert(nil, @id)
	end

	def to_json(options)
		@params.to_json(options)
	end

	def method_missing(method, *args)
		if @params.has_key?(method) || @params.has_key?(method.to_s)
			@params[method]
		else
			super method, *args
		end
	end
end

#at_exit { puts "turkey"; Thought.env.close; Thought.db.close }
Signal.trap('EXIT') { Model.env.close }
Signal.trap('EXIT') { Model.db.close }
