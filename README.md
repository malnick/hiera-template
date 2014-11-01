# Hiera-template
This is a work in progress.

This tool automatically parses a Puppet profile for hiera() statements and adds the keys to a template data file. 

Hiera-templates are our answer to dealing with building out new profiles and the data needed by each one. Every directory of the hieradata directory gets a templates/ directory. In this directory we add base-line templates that have the data for a given profile. 

For example, ```profiles::haproxy```.pp only has data that is at the node/$clientcert level. We create a data template for this profile like:

```hiera-template /path/to/profiles/manifests/haproxy.pp /path/to/hieradata/nodes/templates/haproxy-template.yaml```

When we're ready to boot a new haproxy node, we can cat templates/haproxy-template.yaml > clientcert.yaml and fill in the values for the keys. 

## In-Progress

1. ```hiera-template populate```
	1. Enable a CLI interface to fill in keys
1. Hiera data groups
	1. Enable multi-hierarchy builds (for example, profiles::sso has data on three different hierarchies)
	1. Design ideas: include 'data group keys' in the profile itself to distinguish which sets of data belong in which hierarchy.
		1. hiera-template can then auto-create for each key, represetented by ```#[node]``` or ```#[datacenter]``` tags above the data in the profile. 
		1. Output from above example would be ```$profile_name-$data_group-template.yaml```
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


