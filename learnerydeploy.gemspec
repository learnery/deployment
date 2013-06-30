# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'learnerydeploy/version'

Gem::Specification.new do |spec|
  spec.name          = "learnerydeploy"
  spec.version       = Learnerydeploy::VERSION
  spec.authors       = ["Dr Blinken"]
  spec.email         = ["drblinken@gmail.com"]
  spec.description   = %q{Adds deployment to learnery}
  spec.summary       = %q{Contains a rake tasks that deploys a learnery app to heroku}
   spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
#  spec.add_dependency 'heroku_headless'
end
