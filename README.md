# Purest (or Pure Rest, if you will) -- a simple gem for interacting with Pure Storage's REST API

A simple to use library for Ruby, inspired by the WeAreFarmGeek's Diplomat gem (seriously, those guys are awesome), allowing for easy interaction with Pure Storage's REST API.

## Disclaimer
This started as sort of a labor of love/learning exercise, and sort of blossomed into this. That being said, it means a few things:

1) I may have made some stupid mistakes in here, if so..so be it. Raise them in issues or submit PRs, and I'll gladly fix/merge if I feel the code submitted carries the spirit of my little project. Odds are I won't reject a PR unless you try to rewrite everything for some obtuse reason I don't agree with.

2) I am not affiliated with Pure Storage, beyond the fact that my company uses their product.

3) This isn't done. What I think of as the 'core' functionality is there- you can manipulate volumes, hosts, and host groups, along with the array itself. I still need to add in classes for ProtectionGroups, Alerts/Messages, SNMP Manager Connections, SSL, Network Interfaces, Hardware, Apps, and Users.

## Requirements

To be captain obvious, this does require you have access to a Pure Storage array.

This library requires you use Ruby 2.3 or above.

# Usage

## Configuration

```
require 'purest'

Purest.configure do |config|
  config.url = "https://purehost.yourdomain.com"
  config.options = {ssl: { verify: true }}
  config.api_version = '1.11'
  config.username = 'api-enabled-user'
  config.password = 'password'
end
```

## API options
The various class methods of this gem turn the provided options into HTTP parameters, and are
named accordingly. For instance, ```Purest::Volume.get({:snap => true})``` translates
to http://purehost.yourdomain.com/api/1.11/volume?snap=true. For a full list
of options for a given class, Pure provides good documentation at:
https://purehost.yourdomain.com/static/0/help/rest/.

Below I'll provide a large group of examples, but I won't be detailing every single method call with all of its possible options, for that I will again refer you to Pure's REST API docs.

# Examples
## Volumes
Getting volumes:
```ruby
# Get the full list of volumes
Purest::Volume.get

# Get a single volume
Purest::Volume.get(:name => 'volume1')

# Get monitoring information about a volume
Purest::Volume.get(:name => 'volume1', :action => 'monitor')

# Get multiple volumes
Purest::Volume.get(:names => ['volume1', 'volume2'])

# Get a list of snapshots
Purest::Volume.get(:snap => true)

# Get a single snapshot
Purest::Volume.get(:name => 'volume1', :snap => true)

# Get multiple snapshots
Purest::Volume.get(:names => ['volume1', 'volume2'], :snap => true)

# List block differences for the specified snapshot
Purest::Volume.get(:name => 'volume1.snap', :show_diff => true, :block_size => 512, :length => '2G')

# List shared connections for a specified volume
Purest::Volume.get(:name => 'volume1', :show_hgroup => true)

# List private connections for a specified volume
Purest::Volume.get(:name => 'volume1', :show_host => true)
```

Creating volumes:

```ruby
# Creating a new volume
Purest::Volume.create(:name => 'volume', :size => '10G')

# Creating a new volume by copying another
Purest::Volume.create(:name => 'volume, ':source => 'other_vol')

# Overwriting a volume by copying another
Purest::Volume.create(:name => 'volume', :source => 'other_vol', :overwrite => true)

# Add a volume to a protection group
Purest::Volume.create(:name => 'volume', :pgroup => 'protection-group')
```

Updating volumes
```ruby
# Growing a volume
Purest::Volume.update(:name => 'volume', :size => "15G")

# Truncate (shrink) a volume
Purest::Volume.update(:name => 'volume', :size => "10G", :truncate => true)

# Rename a volume
Purest::Volume.update(:name => 'volume', :new_name => 'volume_renamed')
```

Deleting volumes

```ruby
# Delete a volume
Purest::Volume.delete(:name => 'volume_to_delete')

# Eradicating a volume
Purest::Volume.delete(:name => 'volume_to_delete', :eradicate => true)

# Deleting a volume from a protection group
Purest::Volume.delete(:name => 'volume', :pgroup => 'pgroup1')
```

## Hosts
Getting hosts:
```ruby
# Get a list of all the hosts on an array
Purest::Host.get

# Get a list of hosts with performance data
Purest::Host.get(:action => 'monitor')

# Get a single host on an array
Purest::Host.get(:name => 'host123')

# Get a list of hosts, by name, on an array
Purest::Host.get(:names => ['host123', 'host456'])

# Get volumes associated with specific host
Purest::Host.get(:name => 'hgroup1', :show_volume => true)
```

Creating hosts:
```ruby
# Create a host
Purest::Host.create({:name => 'host123'})

# Create a host and set ISCSI IQNs
Purest::Host.create(:name => 'host123', :iqnlist => ['iqnstuff-1', 'iqnstuff-2'])

# Add a host to a protection group
Purest::Host.create(:name => 'host123', :protection_group => 'pgroup123')

# Connect a volume to a host
Purest::Host.create(:name => 'host123', :volume => 'volume123')
```

Updating hosts:
```ruby
# Rename a host
Purest::Host.update(:name => 'host123', :new_name => 'host456')

# Set the host username/password for CHAP
Purest::Host.update(:name => 'host123', :host_user => 'username', :host_password => 'supersecretpassword')
```

Deleting hosts:
```ruby
# Delete a host
Purest::Host.delete(:name => 'host123')

# Remove a host from a protection group
Purest::Host.delete(:name => 'host123', :protection_group => 'pgroup123')

# Remove the connection between a host and a volume
Purest::Host.delete(:name => 'host123', :volume => 'volume123')
```

# Physical Arrays

List the attributes on an array:
```ruby
# List all the attributes
Purest::PhysicalArray.get

# List connected arrays
Purest::PhysicalArray.get(:connection => true)
```

Create a connection between two arrays:
```ruby
Purest::PhysicalArray.create(:connection_key => '<key>', :management_address => 'hostname', :type => ['replication'])
```

Update the attributes on an array:
```ruby
# rename an array
Purest::PhysicalArray.update(:new_name => 'new_name')
```

Disconnect the current array from a specified array:
```ruby
# Given that your pure is purehost.yourdomain.com, as defined in the config block above
# Disconnect purehost2.yourdomain.com from yours
Purest::PhysicalArray.delete(:name => 'purehost2.yourdomain.com')
```

# Host Groups
Getting information about host groups
```ruby
# Get a list of host groups
Purest::HostGroup.get

# Get a single host group
Purest::HostGroup.get(:name => 'hgroup1')

# Get a list of host groups, with monitoring information
Purest::HostGroup.get(:names => ['hgroup1', 'hgroup2'], :action => 'monitor')

# Get a list of volumes associated with a specified host
Purest::HostGroup.get(:name => 'hgroup1', :show_volume => true)
```

Creating host groups
```ruby
# Create a host group with a specified name
Purest::HostGroup.create(:name => 'hgroup1')

# Create a host group and supply its host members
Purest::HostGroup.create(:name => 'hgroup1', :hostlist => ['host1', 'host2'])

# Add a host group to a protection group
Purest::HostGroup.create(:name => 'hgroup1', :protection_group => 'pgroup1')

# Connect a volume to all hosts in a specified host group
Purest::HostGroup.create(:name => 'hgroup1', :volume => 'v3')
```

Updating host groups
```ruby
# Renaming a host group
Purest::HostGroup.update(:name => 'hgroup1', :new_name => 'hgroup1-renamed')

# Replace the list of member hosts
Purest::HostGroup.update(:name => 'hgroup1', :hostlist => ['host1', 'host2'])

# Add a list of hosts to existing host list
Purest::HostGroup.update(:name => 'hgroup1', :addhostlist => ['host3', 'host4'])

# Remove a list of hosts from a host list
Purest::HostGroup.update(:name => 'hgroup1', :remhostlist => ['host1'])
```

Deleting host groups
```ruby
# Delete a host group
Purest::HostGroup.delete(:name => 'hgroup1')

# Remove a host group member from a protection group
Purest::HostGroup.delete(:name => 'hgroup1', :protection_group => 'pgroup1')

# Break the connection between a host group and a volume
Purest::HostGroup.delete(:name => 'hgroup1', :volume => 'volume1')
```

# Specs
This library is tested with rspec, to execute the specs merely run
```
rspec
```

This project also supports an integration test suite. However, you must have API access to a pure array for this integration test suite to work.

Create an .integration.yaml inside the project, containing your pure array URL and credentials like so:
```
$ cat ~/ruby/purest/.integration.yaml
---
username: 'api-user'
password: 'api-password'
url: 'https://yoursuperawesomepurehost.com'
```

There are a few ways you can execute the integration tests:
```
# This will execute against the latest API version the gem is aware of, right now that is 1.11
rspec -t integration

# This will execute against a specific version
API_VERSION=1.10 rspec -t integration

# This will execute against all specified versions
API_VERSION=1.1,1.2,1.5 rspec -t integration

# And finally, if you wish to execute integration tests against every version
ALL_VERSIONS=true rspec -t integration
```

By default, this will run against version 1.1 to 1.11 of the API. This is useful for ensuring functionality added/subtracted to this project is programmatically tested against all versions of the API. I mostly did this as an exercise, that being said I think it provides a lot of usefulness and if it can be improved let me know (or submit a PR).

It is worth mentioning, this generates a fair bit of work for your Pure array so...you've been warned.
