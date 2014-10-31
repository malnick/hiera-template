#!/usr/bin/ruby

require 'yaml'
require 'logger'
require 'optparse'

$LOAD_PATH << '.'
#require 'populate'

module Template
	class Create
		#include Extras 
		def initialize(profile_path, new_template_path)
			# Parse options
			params,files = parseopts(ARGV)

			# Log it
			@log		= Logger.new(STDOUT) 
			@log.level	= params[:logger_level] || Logger::INFO
			if params[:logger_level] == Logger::DEBUG
				debug("Logger set to DEBUG")
			else
				info("Logger set to INFO")
			end
			
			# Init some class vars
			@new_template_path 	= files[1] 
			@profile_path 		= files[0]
#			@hiera_data_path 	= Extras.get_hiera_data_path
			@keys 			= Hash.new 
			
			# Kick back to stdout 
			debug("In init definition")
			info("Creating new template for #{@profile_path}")
			info("New template path #{@new_template_path}")

			# Run it 
			parse()
			write()
		end

		def parseopts(argv)
			params = {}
			parser = OptionParser.new 

			parser.on("-D") { 
				params[:logger_level] = Logger::DEBUG
			}

			parser.on("-s") { 
				params[:squeeze_extra_newlines] = true               
			}

			files = parser.parse(ARGV)

			[params,files]
		end

		def parse
			info("Parsing #{@profile_path}")
			profile = File.open(@profile_path)
			profile.each_line do |line|
				if line.match(/hiera\(/)
					debug("Data item found: #{line}")
					data = line.split("(").last.chomp
					debug("Data item split to: #{data}")
					data.delete! (")")
					data.delete! ("\"")
					data.delete! ("'")
					data.delete! (",")
					data.strip!
					debug("Data item after deletes: #{data}")
					@keys[data] = nil 
					info("Adding #{data}")
				end
			end
			debug("Keys Collected: #{@keys}")
		end

		def write
			info("Writing keys to new template #{@new_template_path}")
			template = File.open(@new_template_path, 'w')
			@keys.to_hash
			template.write(@keys.to_yaml)
			template.close
		end

		def verify(path)
			unless path.absolute?
				error("Path #{path} must be absolute")
			end
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
end
