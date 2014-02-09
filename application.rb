$:.unshift File.dirname(__FILE__) + "/lib"

require 'dbm_orm'
if ENV['ORM'] == "production"
	Model.dir = './db'
else
	Model.dir = './test/db'
end
require 'thought'
require 'picture'

#Debugger.settings[:autoeval] = true
#Debugger.settings[:autolist] = 1
#Debugger.settings[:reload_source_on_change] = true

def rdebug
	Debugger.wait_connection = true
	Debugger.start_remote
	debugger
end
