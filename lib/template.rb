require 'yaml'
#require './config'

module Template
	class Create

		def initialize(new_template_path, profile_path)
		#	unless new_template_path.absolute? && profile_path.absolute? 
		#		abort "New template & profile path must be absolute"
		#	end
			@new_template_path 	= new_template_path
			@profile_path 		= profile_path
			#@hiera_data_path 	= Config.get_hiera_data_path
			@keys 			= Hash.new 
			puts "Creating new template for #{@profile_path}"
			puts "New template path: #{@new_template_path}"
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
			#@keys.each do |k|
			#	template.write(k.to_yaml)
			#end
			template.close
		end
	end
end
