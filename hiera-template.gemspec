# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
spec.name          = "hiera-template"
spec.version       = '1.0'
spec.authors       = ["Jeff Malnick"]
spec.email         = ["malnick@gmail.com"]
spec.summary       = %q{Create hiera templates}
spec.license       = "MIT"
spec.files         = ['lib/template.rb']
spec.executables   = ['bin/create_template.rb']
spec.require_paths = ["lib"]
end
