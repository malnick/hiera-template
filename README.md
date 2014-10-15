# Hiera-template
Have you ever struggled managing a large volume of hiera data that specific profiles need? 

This tool will parse your profile, and write out a yaml file called $profile_name-template.yaml that you can cat >> into your node level or whatever part of your hierarchy you need the profile keys in. Fill in the values manually. 

