# Grab the --pass-openstack-environment option from the command line if it's there,
# and set that on Chef::Config[:knife] so that we can access it in our redefinition
# of Net::SSH.configuration_for below.
class Chef
  class Knife
    class Ssh < Knife
      option :pass_openstack_environment,
        :long => "--pass-openstack-environment",
        :description => "Pass the openstack environment (defined in your knife.rb) along as environment variables when running chef-client through knife ssh",
        :boolean => true,
        :default => false

      if !method_defined?(:ssh_command_with_environment_variables)
        def ssh_command_with_environment_variables(command, subsession=nil)
          Chef::Config[:knife][:pass_openstack_environment] = if config[:pass_openstack_environment]
            config[:pass_openstack_environment]
          else
            Chef::Config[:knife][:pass_openstack_environment]
          end
          ssh_command_without_environment_variables(command, subsession)
        end
        alias_method :ssh_command_without_environment_variables, :ssh_command
        alias_method :ssh_command, :ssh_command_with_environment_variables
      end
    end
  end
end

require 'net/ssh'

# Add OS_* to the SendEnv ssh option if we've turned on the knife option to pass
# the OpenStack environment.
module Net
  module SSH
    class << self
      if !method_defined?(:configuration_for_with_environment_variables)
        def configuration_for_with_environment_variables(host, use_ssh_config=true)
          ssh_config = configuration_for_without_environment_variables(host, use_ssh_config)
          if Chef::Config[:knife][:pass_openstack_environment]
            ssh_config[:send_env] = ssh_config[:send_env] + [/^OS_.*$/]
          end
          ssh_config
        end
        alias_method :configuration_for_without_environment_variables, :configuration_for
        alias_method :configuration_for, :configuration_for_with_environment_variables
      end
    end
  end
end