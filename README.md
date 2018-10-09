# Purest (or Pure Rest, if you will) -- a simple gem for interacting with Pure Storage's REST API

A simple to use library for Ruby, inspired by the WeAreFarmGeek's Diplomat gem (seriously, those guys are awesome), allowing for easy interaction with Pure Storage's REST API.

## Disclaimer
This started as sort of a labor of love/learning exercise, and sort of blossomed into this. That being said, it means a few things:

1) I may have made some stupid mistakes in here, if so..so be it. Raise them in issues or submit PRs, and I'll gladly fix/merge if I feel the code submitted carries the spirit of my little project. Odds are I won't reject a PR unless you try to rewrite everything for some obtuse reason I don't agree with.

2) I am not affiliated with Pure Storage, beyond the fact that my company uses their product.

3) While all of the classes exist, currently only up to API version 1.12 is 'officially' supported- meaning it may work on newer versions, but I can't verify since I've only been able to develop against versions 1.12 and lower.

Table of contents
=================

<!--ts-->
   * [Requirements](#requirements)
   * [Installation](#installation)
   * [Configuration](#configuration)
   * [Usage](#usage)
      * [Alerts](#alerts)
      * [Apps](#app)
      * [Certs](#cert)
      * [Directory Service](#directory-service)
      * [DNS](#dns)
      * [Drives](#drive-information)
      * [Hardware](#hardware)
      * [Hosts](#hosts)
      * [Host Groups](#host-groups)
      * [Messages](#messages)
      * [Network](#network)
      * [Physical Arrays](#physical-arrays)
      * [Ports](#port)
      * [Protection Groups](#protection-groups)
      * [SNMP](#snmp)
      * [Subnets](#subnet)
      * [Users](#users)
      * [Volumes](#volumes)
   * [Specs](#specs)
<!--te-->

## Requirements

To be captain obvious, this does require you have access to a Pure Storage array.

This library requires you use Ruby 2.3 or above.

## Installation
```
gem install purest
```

## Configuration
```rb
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
First: Authentication and session management are handled behind the scenes, you just need to supply your username/password in the configuration block (as shown in the example above). That's it.

Second: The various class methods of this gem turn the provided options into HTTP parameters, and are
named accordingly. For instance, ```Purest::Volume.get({:snap: true})``` translates
to http://purehost.yourdomain.com/api/1.11/volume?snap=true. For a full list
of options for a given class, Pure provides good documentation at:
https://purehost.yourdomain.com/static/0/help/rest/.

Below I'll provide a large group of examples, but I won't be detailing every single method call with all of its possible options, for that I will again refer you to Pure's REST API docs.

# Usage

## Alerts
Get information about alerts/alerting
```ruby
# List email recipients
Purest::Alerts.get

# List information about a specific email recipient
Purest::Alerts.get(name: 'email@example.com')
```

Designate an email address to receive alerts
```ruby
Purest::Alerts.create(name: 'new-user@example.com')
```

Updating/performing alert actions
```ruby
# Send a test alert
Purest::Alerts.update(action: 'test')

# Turn off alert sending for new-user@example.com
Purest::Alerts.update(name: 'new-user@example.com', enabled: false)
```

Deleting an email address from list of addresses that receive alerts
```ruby
Purest::Alerts.delete(name: 'new-user@example.com')
```

## App
```ruby
# Teeny tiny class, can get apps or get apps and initiators
Purest::App.get
Purest::App.get(initiators: true)
```

## Cert
List certificate attributes or export a certificate
```ruby
# Get certificate attributes
Purest::Cert.get

# Export current certificate
Purest::Cert.get(certificate: true)

# Export current intermediate certificate
Purest::Cert.get(intermediate_certificate: true)

# Get a CSR with current certificate attributes
Purest::Cert.get(csr: true)

# Get a CSR with current certificate attributes, but change the CN
Purest::Cert.get(csr: true, common_name: 'host.example.com')
```

Create self signed certificate, or import one. If you're wondering why this
is an update action and not a create action, I believe it comes down to the fact
that the Pure Array already has a self signed cert from the get go so we're just updating in place.
```ruby
# Create a self signed certificate, using existing attributes
Purest::Cert.update(self_signed: true)

# Create a self signed cert, using all existing attributes except the state
Purest::Cert.update(self_signed: true, state: 'FL')

# Import a cert signed by a CA
Purest::Cert.update(certificate: 'your_huge_certificate_string')
```

## Directory Service
Get information about directory service
```ruby
Purest::DirectoryService.get
```

Update information about a directory service
```ruby
Purest::DirectoryService.update(bind_password: 'superpassword')
```

## DNS
Listing DNS attributes
```ruby
Purest::DNS.get
```

Updating DNS attributes
```ruby
Purest::DNS.update(nameservers: ['newdns1', 'newdns2'])
```

## Drive information
List flash modules, NVRAM modules, and their attributes
```ruby
Purest::Drive.get

Purest::Drive.get(name: 'SH0.BAY0')
```

## Hardware
List hardware components
```ruby
Purest::Hardware.get

# List a specific hardware component's attributes
Purest::Hardware.get(name: 'SH0.BAY0')
```

Control visual identification of specified components
```ruby
# Turn the lights on
Purest::Hardware.update(name: 'SH0.BAY0', identify: on)

# Turn the lights off :(
Purest::Hardware.update(name: 'SH0.BAY0', identify: off)
```

## Hosts
Getting hosts:
```ruby
# Get a list of all the hosts on an array
Purest::Host.get

# Get a list of hosts with performance data
Purest::Host.get(action: 'monitor')

# Get a single host on an array
Purest::Host.get(name: 'host123')

# Get a list of hosts, by name, on an array
Purest::Host.get(names: ['host123', 'host456'])

# Get volumes associated with specific host
Purest::Host.get(name: 'hgroup1', show_volume: true)
```

Creating hosts:
```ruby
# Create a host
Purest::Host.create(name: 'host123')

# Create a host and set ISCSI IQNs
Purest::Host.create(name: 'host123', iqnlist: ['iqnstuff-1', 'iqnstuff-2'])

# Add a host to a protection group
Purest::Host.create(name: 'host123', protection_group: 'pgroup123')

# Connect a volume to a host
Purest::Host.create(name: 'host123', volume: 'volume123')
```

Updating hosts:
```ruby
# Rename a host
Purest::Host.update(name: 'host123', new_name: 'host456')

# Set the host username/password for CHAP
Purest::Host.update(name: 'host123', host_user: 'username', host_password: 'supersecretpassword')
```

Deleting hosts:
```ruby
# Delete a host
Purest::Host.delete(name: 'host123')

# Remove a host from a protection group
Purest::Host.delete(name: 'host123', protection_group: 'pgroup123')

# Remove the connection between a host and a volume
Purest::Host.delete(name: 'host123', volume: 'volume123')
```

## Host Groups
Getting information about host groups
```ruby
# Get a list of host groups
Purest::HostGroup.get

# Get a single host group
Purest::HostGroup.get(name: 'hgroup1')

# Get a list of host groups, with monitoring information
Purest::HostGroup.get(names: ['hgroup1', 'hgroup2'], action: 'monitor')

# Get a list of volumes associated with a specified host
Purest::HostGroup.get(name: 'hgroup1', show_volume: true)
```

Creating host groups
```ruby
# Create a host group with a specified name
Purest::HostGroup.create(name: 'hgroup1')

# Create a host group and supply its host members
Purest::HostGroup.create(name: 'hgroup1', hostlist: ['host1', 'host2'])

# Add a host group to a protection group
Purest::HostGroup.create(name: 'hgroup1', protection_group: 'pgroup1')

# Connect a volume to all hosts in a specified host group
Purest::HostGroup.create(name: 'hgroup1', volume: 'v3')
```

Updating host groups
```ruby
# Renaming a host group
Purest::HostGroup.update(name: 'hgroup1', new_name: 'hgroup1-renamed')

# Replace the list of member hosts
Purest::HostGroup.update(name: 'hgroup1', hostlist: ['host1', 'host2'])

# Add a list of hosts to existing host list
Purest::HostGroup.update(name: 'hgroup1', addhostlist: ['host3', 'host4'])

# Remove a list of hosts from a host list
Purest::HostGroup.update(name: 'hgroup1', remhostlist: ['host1'])
```

Deleting host groups
```ruby
# Delete a host group
Purest::HostGroup.delete(name: 'hgroup1')

# Remove a host group member from a protection group
Purest::HostGroup.delete(name: 'hgroup1', protection_group: 'pgroup1')

# Break the connection between a host group and a volume
Purest::HostGroup.delete(name: 'hgroup1', volume: 'volume1')
```

## Messages
List alert events, audit records, etc
```ruby
Purest::Messages.get
```

Flag/unflag a message
```ruby
Purest::Messages.update(id: 2, flagged: true)
```

## Network
List network interfaces
```ruby
# Get network interfaces and their statuses
Purest::Network.get

# Get attributes about a specific network component
Purest::Network.get(name: 'ct0.eth0')
```

Create a VLAN interface
```ruby
# Create a vlan with a specified subnet
Purest::Network.create(subnet: 'subnet10')
```

Perform network interface actions or update attributes
```ruby
# Set MTU
Purest::Network.update(mtu: 2000)
```

Delete a VLAN interface
```ruby
Purest::Network.delete(name: 'ct0.eth0')
```

## Physical Arrays

List the attributes on an array:
```ruby
# List all the attributes
Purest::PhysicalArray.get

# List connected arrays
Purest::PhysicalArray.get(connection: true)
```

Create a connection between two arrays:
```ruby
Purest::PhysicalArray.create(connection_key: '<key>', management_address: 'hostname', type: ['replication'])
```

Update the attributes on an array:
```ruby
# rename an array
Purest::PhysicalArray.update(new_name: 'new_name')
```

Disconnect the current array from a specified array:
```ruby
# Given that your pure is purehost.yourdomain.com, as defined in the config block above
# Disconnect purehost2.yourdomain.com from purehost.yourdomain.com
Purest::PhysicalArray.delete(name: 'purehost2.yourdomain.com')
```

## Port
Getting information about ports, 'cause that's all you get to do
```ruby
# Get port information
Purest::Port.get

# Get port information + initiator information = winning
Purest::Port.get(initiators: true)
```

## Protection Groups
Getting information about protection groups
```ruby
# Get a list of protection groups
Purest::ProtectionGroup.get

# Get a list of protection groups pending deletion
Purest::ProtectionGroup.get(pending: true)
```

Creating protection groups
```ruby
# Create a protection group
Purest::ProtectionGroup.create(name: 'pgroup1')

# Create a protection group with a host list
Purest::ProtectionGroup.create(name: 'pgroup1', hostlist: ['host1', 'host2'])
```

Updating protection groups
```ruby
# Renaming a protection group
Purest::ProtectionGroup.update(name: 'pgroup1', new_name: 'pgroup1-renamed')

# Add a list of hosts to an existing protection group's host list
Purest::ProtectionGroup.update(name: 'pgroup1', addhostlist: ['host3', 'host4'])
```

Deleting a protection group
```ruby
# Delete it, but allow for it to remain during the 24 hour grace period
Purest::ProtectionGroup.delete(name: 'pgroup1')

# Delete it, with extreme prejudice
Purest::ProtectionGroup.delete(name: 'pgroup1', eradicate: true)
```

## SNMP
Getting SNMP information
```ruby
# Get a list of SNMP managers
Purest::SNMP.get

# List SNMP v3 engine ID
Purest::SNMP.get(engine_id: true)
```

Creating an SNMP manager
```ruby
# Create an SNMP manager
Purest::SNMP.create(name: 'snmp-manager1', host: 'snmp.yourdomain.com')

# Create an SNMP manager pointed at an IPv4 address with a custom port
Purest::SNMP.create(name: 'snmp-manager1', host: '111.11.11.111:222')

# For those brave few; the strong souls using IPv6 with a custom port
Purest::SNMP.create(name: 'snmp-manager1', host: '[2001:db8:0:1]:222')
```

Updating an existing SNMP manager
```ruby
# Renaming an SNMP manager
Purest::SNMP.update(name: 'snmp-manager1', new_name: 'snmp-manager-renamed')

# For those not so brave; the weak souls who give up using IPv6 with a custom port
Purest::SNMP.update(name: 'snmp-manager1', host: '111.11.11.111:222')
```

Deleting an SNMP manager
```ruby
# Delete an SNMP manager
Purest::SNMP.delete(name: 'snmp-manager1')
```

## Subnet
Getting information about subnets
```ruby
Purest::Subnet.get

# Specify a subnet
Purest::Subnet.get(name: 'subnet10')
```

Creating a subnet
```ruby
Purest::Subnet.create(name: 'subnet20', gateway: '11.11.11.1')
```

Updating a subnet
```ruby
# Rename a subnet
Purest::Subnet.update(name: 'subnet20', new_name: 'subnet21')
```

Deleting a subnet
```ruby
Purest::Subnet.delete(name: 'subnet21')
```

## Users
Getting information about users
```ruby
Purest::Users.get

# Specific user information
Purest::Users.get(name: 'paxton.fettle')

# List the API token of a given user
Purest::Users.get(name: 'paxton.fettle', api_token: true)
```

Create an API token for an existing user
```ruby
Purest::Users.create(name: 'paxton.fettle')
```

Updating user related stuff
```ruby
# Clear all user permission cache entries
Purest::Users.update(clear: true)

# Update a specific user's public key
Purest::Users.update(name: 'paxton.fettle', publickey: 'hugepublickeystring')
```

Delete API token for a user
```ruby
Purest::Users.delete(name: 'paxton.fettle')
```

## Volumes
Getting volumes:
```ruby
# Get the full list of volumes
Purest::Volume.get

# Get a single volume
Purest::Volume.get(name: 'volume1')

# Get monitoring information about a volume
Purest::Volume.get(name: 'volume1', action: 'monitor')

# Get multiple volumes
Purest::Volume.get(names: ['volume1', 'volume2'])

# Get a list of snapshots
Purest::Volume.get(snap: true)

# Get a single snapshot
Purest::Volume.get(name: 'volume1', snap: true)

# Get multiple snapshots
Purest::Volume.get(names: ['volume1', 'volume2'], snap: true)

# List block differences for the specified snapshot
Purest::Volume.get(name: 'volume1.snap', show_diff: true, block_size: 512, length: '2G')

# List shared connections for a specified volume
Purest::Volume.get(name: 'volume1', show_hgroup: true)

# List private connections for a specified volume
Purest::Volume.get(:name: 'volume1', :show_host: true)
```

Creating volumes:

```ruby
# Creating a new volume
Purest::Volume.create(name: 'volume', size: '10G')

# Creating a new volume by copying another
Purest::Volume.create(name: 'volume', source: 'other_vol')

# Overwriting a volume by copying another
Purest::Volume.create(name: 'volume', source: 'other_vol', overwrite: true)

# Add a volume to a protection group
Purest::Volume.create(name: 'volume', protection_group: 'protection-group')
```

Updating volumes
```ruby
# Growing a volume
Purest::Volume.update(name: 'volume', size: "15G")

# Truncate (shrink) a volume
Purest::Volume.update(name: 'volume', size: "10G", truncate: true)

# Rename a volume
Purest::Volume.update(name: 'volume', new_name: 'volume_renamed')
```

Deleting volumes

```ruby
# Delete a volume
Purest::Volume.delete(name: 'volume_to_delete')

# Eradicating a volume
Purest::Volume.delete(name: 'volume_to_delete', eradicate: true)

# Deleting a volume from a protection group
Purest::Volume.delete(name: 'volume', protection_group: 'pgroup1')
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


It is worth mentioning, this generates a fair bit of work for your Pure array so...you've been warned. All of that being said, the integration testing is somewhat sparse at the moment
