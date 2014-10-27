#!/usr/bin/env ruby

$LOAD_PATH << '.'
require '../lib/template'

template = Template::Create.new(ARGV[1], ARGV[0])
#template.create_new_template(ARGV[1])
