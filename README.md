# rhel-local-mirrors

This is a set of playbooks to automate the local mirror creation
for RHEL repos in a system. It will perform two steps:
1. Subscribe the system into the RedHat network
2. Create local mirors for the repos specified

## How to use

The playbooks expect a group of servers called ``rhel_mirrors`` to be
created. Please create the group and add the servers for the ansible inventory
you would like to use.
It also expects a file  ~/.ansible/vars/rhel_local_mirrors_vars.yml to be
created, and populated with the settings you need to override.

After that, just run ``ansible-playbook site.yml -i /path/to/inventory``

## RHN subscription                                                             

On a Red Hat system, subscription of can be managed automatically        
if you pass the right credentials:                                              
* rhn_subscription_username                                                     
* rhn_subscription_password                                                     
* rhn_subscription_pool_id

Also the following vars are set by default:
* subscribe_rhn: by default set to true, change if you want to skip the subscription step
* rhn_repos: list, by default set to the OSP10 repos. Please update it if you want to allow more repos
