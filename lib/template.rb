require 'yaml'
require './config'


module template
	class create
		attr_accessor :profile_path
		# Grab hiera data path from config
		@hiera_data_path = Config.get_hiera_data_path
		@keys = []

		def create_new_template(:new_template_path)

			new_file = File.new(:new_template_path, 'w')
			puts "Writing the new template to: ", :new_template_path
			@keys.each do | key | 
				new_file.write(key)
			end
			new_file.close
		end

		def Self.get_data_from_profile(:profile_path)
			# Parse the profile for all hiera() data keys. 			
		end
	end


end
