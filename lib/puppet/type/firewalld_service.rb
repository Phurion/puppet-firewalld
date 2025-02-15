require 'puppet'

Puppet::Type.newtype(:firewalld_service) do
  @doc = "Assigns a service to a specific firewalld zone.
    firewalld_service will autorequire the firewalld_zone specified in the zone parameter and the firewalld::custom_service
		specified in the service parameter, so there is no need to add dependencies for this

    Example:

        firewalld_service {'Allow SSH in the public Zone':
            ensure  => 'present',
            zone    => 'public',
            service => 'ssh',
        }

  "

  ensurable do
    newvalue(:present) do
      @resource.provider.create
    end

    newvalue(:absent) do
      @resource.provider.destroy
    end

    defaultto(:present)
  end

  newparam(:name, namevar: :true) do
    desc 'Name of the service resource in Puppet'
  end

  newparam(:service) do
    desc 'Name of the service to add'
    defaultto { @resource[:name] }
  end

  newparam(:zone) do
    desc 'Name of the zone to which you want to add the service'
  end

  autorequire(:firewalld_zone) do
    self[:zone]
  end

  autorequire(:service) do
    catalog.resources.select do |res|
      res.title == "Firewalld::Custom_service[#{self[:service]}]"
    end
  end
end
