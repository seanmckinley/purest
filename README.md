# Purest -- a simple gem for interacting with Pure Storage's REST API

A simple to use library for Ruby, inspired by the WeAreFarmGeek's Diplomat gem (seriously, those guys are awesome), allowing for easy interaction with Pure Storage's REST API.

## Requirements

To be captain obvious, this does require you have access to a Pure Storage array.

I wrote this using Ruby 2.5.1 testing against API version 1.11 (so far), but I imagine anything 2.0+ will be fine- I haven't done anything too crazy. I also imagine any api version > 1.0 will work, but I can't speak to that with certainty- if you notice breakage or oddities with older versions raise an issue and I'll check it out.

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
volumes = Purest::Volume.get

# Get a single volume
volume = Purest::Volume.get(:name => 'volume1')

# Get monitoring information about a volume
volume = Purest::Volume.get(:name => 'volume1', :action => 'monitor')

# Get multiple volumes
volumes = Purest::Volume.get(:names => ['volume1', 'volume2'])

# Get a list of snapshots
snapshots = Purest::Volume.get(:snap => true)

# Get a single snapshot
snapshot = Purest::Volume.get(:name => 'volume1', :snap => true)

# Get multiple snapshots
snapshots = Purest::Volume.get(:names => ['volume1', 'volume2'], :snap => true)
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

Execute integration tests:
```
rspec -t integration
```

By default, this will run against version 1.1 to 1.11 of the API. This is useful for ensuring functionality added/subtracted to this project is programmatically tested against all versions of the API.

It is worth mentioning, this generates a fair bit of work for your Pure array so...you've been warned.
