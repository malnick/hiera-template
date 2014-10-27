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
			@keys 			= []
			puts "Creating new template for #{@profile_path}"
			puts "New template path: #{@new_template_path}"
			parse()
			#create(@new_template_path)
		end

		def parse
			profile = File.open(@profile_path)
			profile.each_line do |line|
				if line.match(/hiera/)
					data = line.split("(").last
					data.delete! (")")
					data.delete! ("\"")
					data.delete! ("'")
					puts "Data: #{data}"
				end

			end

		end
	end
		#def self.(er:new_template_path)

		#	new_file = File.new(:new_template_path, 'w')
		#	puts "Writing the new template to: ", :new_template_path
		#	@keys.each do | key | 
		#		new_file.write(key)
		#	end
		#	new_file.close
		#end

		#def Self.get_data_from_profile(:profile_path)
		#	# Parse the profile for all hiera() data keys. 			
		#	# Add keys to @keys
		#end
end
