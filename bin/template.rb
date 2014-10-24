#!/usr/bin/env ruby

require 'template'

template = Template::Create.new
template.create_new_template(ARGV[1])
