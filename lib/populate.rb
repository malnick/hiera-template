require 'logger'
require 'yaml'

class Populate
	def initialize(data_group)
		@log            = Logger.new(STDOUT)
		@log.level	= Logger::DEBUG
		@hiera_dir	= File.join(Dir.home, ".hiera-template")
		params 		= get_config()
		debug("Params: #{params}")
		info("Creating new datafile(s) for #{data_group}")
	end

	def get_config()
		params = {}
		
		unless Dir.exists?("~/.hiera-template") 
			Dir.mkdir("~/.hiera-template")
		end
		

		unless File.exists?('~/.hiera-template/config.yaml')
			warn("config.yaml not found, creating ~/.hiera-template/config.yaml")
			params = {
				'configpath' 	=> '~/.hiera-template/',
				'templatepath'	=> '~/.hiera-template/templates',
				'hierarchy'	=> ['global', 'nodes/node', 'datacenters/datacenter' ]
			}
			debug("Baseline params hash: #{params}")
			f = File.open('~/.hiera-template/config.yaml','w')
			f.write(params.to_yaml)
			f.close

		end

		#File.open("~/.hiera-template/config.yaml", 'r') {|f|
		#	f.readlines {|line|
			# parse the yaml, add it to the params {}
		#	}
		#}
		
		params
	end

	def error(message)
		@log.error(message)
		abort
	end

	def debug(message)
		@log.debug(message)
	end

	def warn(message)
		@log.warn(message)
	end

	def info(message)
		@log.info(message)
	end
end

