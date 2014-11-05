module Populate

	def Populate.working()
		puts "working"
	end

	def Populate.new_data_file()
		get_config()
		

	end

	def Populate.get_config()
		params = {}
		unless Dir.exists?('~/.hiera-template')
			Logger.info('Please run hiera-tempalte $profile_path to create templates')
		end

		unless File.exists?('~/.hiera-template/config.yaml')
			params = {
				'configpath' 	=> '~/.hiera-template/',
				'templatepath'	=> '~/.hiera-template/templates',
				'hierarchy'	=> ['global', 'nodes/node', 'datacenters/datacenter' ]
			}

			File.open('~/.hiera-template/config.yaml','w') {|f|
				f.write(params.to_yaml)
			}
		end

		#File.open("~/.hiera-template/config.yaml", 'r') {|f|
		#	f.readlines {|line|
			# parse the yaml, add it to the params {}
		#	}
		#}
		
		
	end

	def Populate.log
		@log            = Logger.new(STDOUT)
	end
end

