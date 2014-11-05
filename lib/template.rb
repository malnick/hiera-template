require 'yaml'
require 'logger'
require "optparse"

$LOAD_PATH << '.'

module Template 
	class Create
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
			@keys 			= Hash.new 
			@data_groups		= Hash.new 
			@data_groups["unknown"] = @current_group = []
			@cwd = File.expand_path File.dirname(__FILE__)
	

			# Kick back to stdout 
			debug("In init definition")
			info("Creating new template for #{@profile_path}")
			info("New template path #{@new_template_path}")

			# Run it 
			parse()
			debug(@data_groups)
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

			# For each data grouop, parse the file
			profile.each_line do |line| 
				catch :unknown_group do 
					# If the line matches the data group, init a new array for the keys in that data group
					if line.match(/\#\[/)
						debug("Data group found on line: #{line}")
						data_group = line.split('[').last.delete(']').chomp
						info("Creating data group: #{data_group}") 
						@data_groups[data_group] = @current_group = []
						debug("Data groups now include: #{@data_groups}")

					# For all other lines, parse it for keys
					elsif line.match(/hiera\(/)
						debug("Current data group being added to: #{@current_group}")
						debug("Data item found: #{line}")
						data = line.split("(").last.chomp
						data.delete! (")")
						data.delete! ("\"")
						data.delete! ("'")
						data.delete! (",")
						
						@current_group << data
						
						info("Adding #{data}")
						debug("Adding #{data} to #{@current_group} hash")
					end
				end
			end
		end

		def write
			# Create dotdir if needed:
			unless Dir.exists?("#{Dir.home}/.hiera-template")
				Dir.mkdir(File.join(Dir.home, '.hiera-template'), 0755)
			end
			unless Dir.exists?("#{Dir.home}/.hiera-template/templates")
				Dir.mkdir("#{Dir.home}/.hiera-template/templates", 0755)
			end

			temp_path = "#{Dir.home}/.hiera-template/templates"
			profile_name = @profile_path.split("/").last.split(".").first

			@data_groups.each do |k,v|
				write_hash = Hash.new
				v.each do |key|
					write_hash[key] = nil
				end
				info("Writing keys to new template #{temp_path}/#{profile_name}-#{k}-template.yaml")
				template = File.open("#{temp_path}/#{profile_name}-#{k}-template.yaml", "w")
				template.write(write_hash.to_yaml)
				template.close
			end
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
