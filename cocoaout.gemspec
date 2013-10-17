$:.push File.expand_path("../lib", __FILE__)
Gem::Specification.new do |s|
  s.name = "cocoaout"
  s.version = Cocoaout::VERSION
  s.author = "Jason Lee"
  s.email = "huacnlee@gmail.com"
  s.homepage = "https://github.com/huacnlee/cocoaout"
  s.platform = Gem::Platform::RUBY
  s.summary = "Auto build and release tool for Cocoa projects."
  s.description = "Auto build and release tool for Cocoa projects."
  s.required_ruby_version = ">=2.0.0"
  s.licenses = ['Apache V2']

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  s.add_runtime_dependency 'thor', '>= 0.18'
end
