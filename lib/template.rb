require 'yaml'
require 'logger'
$LOAD_PATH << '.'

module Template
	class Create
		#include Extras 
		@log	= Logger.new(STDOUT) 

		def initialize(new_template_path, profile_path)
			@new_template_path 	= new_template_path
			@profile_path 		= profile_path
#			@hiera_data_path 	= Extras.get_hiera_data_path
			@keys 			= Hash.new 
					puts "###"
			puts "Creating new template for #{@profile_path}"
			puts "New template path #{@new_template_path}"
			puts "###"
			parse()
			write()
		end

		def parse
			puts "Parsing #{@profile_path}"
			profile = File.open(@profile_path)
			profile.each_line do |line|
				if line.match(/hiera/)
					data = line.split("(").last.chomp
					data.delete! (")")
					data.delete! ("\"")
					data.delete! ("'")
					#data << ":"
					@keys[data] = 
					puts "Adding #{data}"
				end
			end
			puts "Keys found: "
			puts @keys
		end

		def write
			puts "Writing keys to new template #{@new_template_path}"
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
			logger.error("Fatal error occured: #{message}")
			abort 
		end

		def debug(message)
			logger.debug("DEBUG: ", message)
		end

		def warn(message)
			logger.warn("WARNING: ", message)
		end

		def info(message)
			logger.info("INFO: ", message)
		end

	end
end
