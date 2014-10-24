# Hiera-template
Have you ever struggled managing a large volume of hiera data that specific profiles need? 

## Assumptions
Every subdir in your hiera $datadir has a /templates directory. 

```hiera-template create```

hiera-tempalte will accepts 1 variable: a path to a profile you want to create a template from. 

hiera-template will give you a numeric option menu to choose which hierarchy to write the template to. If the profile calls data from multiple hierarchies, you can give this input multiple numbers. 

If multiple hierarchies are given, hiera-template will run in 'manual' mode (-m) by default: it will present you with the key, and you need to provide it with the number that corrolates to the hierarchy on the CL. 

If only one hierarchy is given, hiera-template will run in 'auto' mode by defualt: it will create a template in the datadir/$key/templates directory with all the keys for that profile. 

```hiera-template populate```

hiera-template populate expects 2 variable: the hierachy level, presented to you as a list with numbered keys you will choose from and a template name.  

hiera-template will read from templates to populate new $hierarchy-level data file with the correct values for the keys in the template.


