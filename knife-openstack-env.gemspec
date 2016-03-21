$:.push File.expand_path("../lib", __FILE__)
require "knife-openstack-env/version"

Gem::Specification.new do |s|
  s.name        = 'knife-openstack-env'
  s.version     = Knife::OpenstackEnv::VERSION
  s.date        = Time.now.strftime("%Y-%m-%d")
  s.summary     = "Pass the local OpenStack environment with knife SSH calls"
  s.description = "Pass the local OpenStack environment with knife SSH calls"
  s.authors     = ["Cybera"]
  s.email       = 'devops@cybera.ca'
  s.homepage    = "https://github.com/cybera/knife-openstack-env"
  s.files       = `git ls-files`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end