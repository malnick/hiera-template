#!/usr/bin/env ruby
require_relative '../lib/template.rb'

Template::Create.new(ARGV[1], ARGV[0])
