# Hiera-template

```gem install hiera-template```

This tool automatically parses a Puppet profile for hiera() statements and adds the keys to a template data file. 

Hiera-templates are our answer to dealing with building out new profiles and the data needed by each one. Every directory of the hieradata directory gets a templates/ directory. In this directory we add base-line templates that have the data for a given profile. 

## Usage
To parse a single profile:

```hiera-template my-profile.pp```

^^ will write template to ```~/.hiera-template/templates/my-profile-unknown-template.yaml```

Why unknown? Because no hierarchy keys were in the profile...

### Hierarchy keys
If you have a profile with data on many levels, key the profile data like:

```ruby
class profiles::csx_frontend_base(
#[node]
$csx_db_name                          = hiera('profiles::csx_frontend_base::csx_db_name'),
$csx_db_user                          = hiera('profiles::csx_frontend_base::csx_db_user'),
$csx_db_password_hash                 = hiera('profiles::csx_frontend_base::csx_db_password_hash'),
$csx_db_host                          = hiera('profiles::csx_frontend_base::csx_db_host'),
#[datacenter]
$csx_db_driverclassname               = hiera('profiles::csx_frontend_base::csx_db_driverclassname'),
$csx_db_url                           = hiera('profiles::csx_frontend_base::csx_db_url'),
$csx_db_password                      = hiera('profiles::csx_frontend_base::csx_db_password'),
$mandrill_apikey                      = hiera('profiles::csx_frontend_base::mandrill_apikey'),
#[global]
$mandrill_username                    = hiera('profiles::csx_frontend_base::mandrill_username'),
$middleware_url                       = hiera('profiles::csx_frontend_base::middleware_url'),
$copper_url                           = hiera('profiles::csx_frontend_base::copper_url'),
```

hiera template will create three files:
```~/.hiera-template/templates/my-profile-node-template.yaml```
```~/.hiera-template/templates/my-profile-datacenter-template.yaml```
```~/.hiera-template/templates/my-profile-global-template.yaml```

Copy the templates to your puppet master data dir, and for each: 
``` cat my-profile-node-template.yaml > my.new.node.com.yaml```

Do the same at the datacenter and global levels (but append rather than write on the global file perhaps...)

## In-Progress

1. ```hiera-template populate```
	1. Enable a CLI interface to fill in keys
1. Config directory in user's home directory
	1. hiera-template.yaml for configuration parameters
		1. default template dir
		1. logging modes
		1. other params
1. Support for parsing non-explicit hiera() lookups:
	1. Given the following:
	
	```ruby
	class profiles::my_profile {
		$variable1,
		$variable2,
	...
	}
	```
	
	
## Workflow
```hiera-template /path/to/profile /path/to/hieradata/${hierarchy-level}/templates/${profile_name}-template.yaml```

## Construction Ideas 
Every subdir in your hiera $datadir has a /templates directory. 

```hiera-template create```

hiera-tempalte will accepts 1 variable: a path to a profile you want to create a template from. 

hiera-template will give you a numeric option menu to choose which hierarchy to write the template to. If the profile calls data from multiple hierarchies, you can give this input multiple numbers. 


If multiple hierarchies are given, hiera-template will run in 'manual' mode (-m) by default: it will present you with the key, and you need to provide it with the number that corrolates to the hierarchy on the CL. 

If only one hierarchy is given, hiera-template will run in 'auto' mode by defualt: it will create a template in the datadir/$key/templates directory with all the keys for that profile. 

```hiera-template populate```

hiera-template populate expects 2 variable: the hierachy level, presented to you as a list with numbered keys you will choose from and a template name.  

hiera-template will read from templates to populate new $hierarchy-level data file with the correct values for the keys in the template.


